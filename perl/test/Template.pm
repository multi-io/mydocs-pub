package Template;

use strict;
use Carp 'croak';

sub new {
    my $self = bless {}, shift;
    $self->load(shift) if @_;
    $self->{out} = shift || *STDOUT;
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
                $templ .= "\$self->quote_expr(scalar($expr)) ." if $expr;
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
    print {$self->{out}} $string;
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
    my $callingpkg = caller();
    # print qq[evaling:\n$self->{templ}\n];
    eval qq[package $callingpkg; $self->{templ}];
    croak $@ if $@;
}


1;
