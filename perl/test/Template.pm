package Template;

use strict;
use Carp 'croak';

sub new {
    my $self = bless {}, shift;
    $self->load(shift) if @_;
    $self->{out} = shift || *STDOUT;
    my $outtype = ref $self->{out};
    # TODO: check for '' needed because of FILEHANDLEs, but means
    # that I can't tell scalar from ref-to-scalar here (only the latter will work)
    unless (($outtype eq '') or ($outtype eq 'SCALAR')) {
        croak "can't output to type $outtype";
    }
    $self;
}


sub load {
    my ($self, $filename) = @_;
    local $/ = "\n";
    open(F, "<$filename") or croak "couldn't open $filename: $!";
    my $templ = "";
    while (<F>) {
        my @line = split /(?=[^\\]?)?<%([^=].*?[^\\]?)%>/;
        for (my ($printed, $code) = (shift @line, shift @line);
             defined $printed;
             ($printed, $code) = (shift @line, shift @line)) {

            $templ .= q[$self->print ( ];
            my @printed = split(/(?=[^\\]?)<%=(.*?[^\\]?)%>/, $printed);
            for (my ($text, $expr) = (shift @printed, shift @printed);
                 defined $text;
                 ($text, $expr) = (shift @printed, shift @printed)) {

                foreach my $x ($text, $expr || do{my $x="";$x}) { $x=~s!\\<%!<%!g; $x=~s!\\>!>!g; }
                $templ .= qq[q($text) . ];
                $templ .= "\$self->quote_expr(scalar(do\{$expr\})) ." if $expr;
            }
            $templ .= q["");];
            $templ .= $code if $code;
        }
    }
    $self->{templ} = $templ;
}


# override to print to string, ... instead of $self->{out}
# and/or apply transformations to the expanded text
sub print {
    my ($self, $string) = @_;
    if (ref($self->{out}) eq '') {
        print {$self->{out}} $string;
    }
    else {
        ${$self->{out}} .= $string;
    }
}

# override to apply some transformation to user expressions
# (e.g. quote HTML/XML metacharacters etc.)
sub quote_expr {
    my ($self, $expr) = @_;
    $expr;  # return the expression without any transformations by default
}


sub run {
    no strict 'vars';
    my ($self) = @_;
    our $callingpkg;  # need dynamic scope for this so include()d sub-templates still get the original calling package's variables
    my $prev_callingpkg = $callingpkg;
    $callingpkg = caller() unless $callingpkg;
    # print qq[evaling:\n$self->{templ}\n];
    eval qq[package $callingpkg; $self->{templ}];
    $callingpkg = $prev_callingpkg;
    croak $@ if $@;
}


sub include {
    my ($self,$filename) = @_;
    $filename = $self unless $filename;
    my $result = "";
    my $subtempl = Template->new($filename, \$result);
    $subtempl->run();
    $result;
}


1;
