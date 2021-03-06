#!/usr/bin/perl -w

use strict;

BEGIN { @INC = ("perl/test", @INC); }

use Template;
use File::Copy;
use File::Basename;
use File::Temp qw/ tempfile /;

sub htmlizable {
    local ($_) = shift;
    m!\.bsh$! or
    m!\.c$! or
    m!\.cc$! or
    m!\.cgi$! or
    m!\.classpath$! or
    m!consign$! or
    m!\.cs$! or
    m!\.css$! or
    m!\.dat$! or
    m!\.dtd$! or
    m!edit$! or
    m!\.el$! or
    m!\.eli$! or
    m!\.env$! or
    m!\.gplot$! or
    m!\.h$! or
    m!\.jad$! or
    m!\.java$! or
    m!\.jpr$! or
    m!\.js$! or
    m!\.latex$! or
    m!\.li$! or
    m!\.launch$! or
    m!\.local$! or
    m!\.log$! or
    m!\.md$! or
    m!\.ml$! or
    m!\.m$! or
    m!\.pac$! or
    m!\.php3$! or
    m!\.pl$! or
    m!\.pm$! or
    m!\.policy$! or
    m!\.project$! or
    m!\.py$! or
    m!\.rb$! or
    m!\.sax2$! or
    m!\.sc$! or
    m!\.show$! or
    m!\.sh$! or
    m!\.sql$! or
    m!\.templ$! or
    m!\.tex$! or
    m!\.txt$! or
    m!\.txt,v$! or
    m!\.url$! or
    m!\.xerces$! or
    m!Makefile$! or
    m!\.xml$! or
    m!wwwpublish$! or
    m!gh-publish$!;
}

sub publish($$);

sub publish($$) {
    # "our" variables are "our" so the template can acces it
    # we use "my" copies of those variables in this routine because
    #    using "our" (i.e. dynamically scoped) variables in recursive
    #    functions tends to be messy
    my ($_dir, $targetdir) = @_;
    print STDERR "publishing: $targetdir\n";
    unless (-d $targetdir) {
        mkdir $targetdir or die "couldn't mkdir $targetdir: $!";
    }
    open(IDXHTM, ">$targetdir/index.html");
    my $_target_templ = "wwwpublish.d/index.templ";
    my $tpl = Template->new("wwwpublish.d/wrapper.templ", *IDXHTM);

    our $dir = $_dir;
    our $target_templ = $_target_templ;
    $tpl->run();

    close IDXHTM;

    foreach my $_f (@{$_dir->{FILES}}) {
        my $_fqsrcname = "$_dir->{PATH}$_f";

        copy($_fqsrcname, "${targetdir}/$_f");
        
        if (htmlizable($_fqsrcname)) {
            htmlize($_fqsrcname, "${targetdir}/$_f.html");
        }
    }

    foreach my $d (@{$dir->{DIRS}}) {
        publish($d, "$targetdir/$d->{NAME}");
    }
}


sub htmlize($$) {
    my ($srcname, $destname) = @_;
    my ($ext) = basename($srcname) =~ /(\.[^.]+)$/;
    $ext = '' unless $ext;

    for ($ext) {
        /\.md$/ and do {

            # markdown to html
            # TODO: use pandoc templates rather than rolling our own?

            open(SRC, "<$srcname") or die "couldn't open $srcname: $!";
            local $/=undef;
            our $text = <SRC>;  # for file_md.templ below
            close SRC;

            our $f = basename($destname, '.html');
            our $fqsrcname = $srcname;

            my ($full_md_fd, $full_md_fn) = tempfile();
            my $tpl = Template->new("wwwpublish.d/file_md.templ", *$full_md_fd);
            $tpl->run();
            
            system('pandoc', $full_md_fn, '-o', $destname) == 0 or die "pandoc $full_md_fn -o $destname failed: $?";

            unlink $full_md_fn;
            
            last;
        };

        # fallback -- generic text to html

        open(SRC, "<$srcname") or die "couldn't open $srcname: $!";
        local $/=undef;
        my $_text = <SRC>;
        close SRC;
        
        our $target_templ = "wwwpublish.d/file.templ";
        open(DEST, ">$destname");
        my $tpl = Template->new("wwwpublish.d/wrapper.templ", *DEST);

        our $f = basename($destname, '.html');
        our $fqsrcname = $srcname;
        our $text = $_text;
        $tpl->run();

        close DEST;
    }

}


# for use by templates
sub htmlescape {
    $_=shift;
    my $repl = rand() . rand() . rand();
    my $replre = qr/$repl/;
    s!&!$repl!sig;
    s!<!&lt;!sig;
    s!>!&gt;!sig;
    s!$replre!&amp;!sig;
    $_;
}

1;
