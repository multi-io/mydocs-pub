use Data::Dumper;
use Cwd;
use Tk;
if ($Tk::version == 4.0) {
  require "MultiFileSelect.pm";
} else {
  use Tk::FileSelect;
}
#use TkUtils;
use File::Basename;
use File::Copy;
use strict;


my $VERSION = "1.009 (early-access2)";	# Version number 
my ($DEBUG) = 0;		# Debug mode on/off
my ($DEBUGFILE);		# Location of debug file
my ($RCFILE);			# Location of resource file
my ($RCDIR);			# Location of resource dir
my ($PREFS);			# Preferences file
my ($CANCEL);			# global cancel flag


$RCDIR="/home/olaf/tmp/tmp";

my $gWm = MainWindow->new(-title => "fselect test");

sub btnCallback {
    my ($file, @files);

    unless (defined($PREFS->{"lastdir"}))
    {
        chomp($PREFS->{"lastdir"} = Cwd::cwd() || Cwd::fastcwd() || `pwd`);
    }



    my @params = (
                  -directory => $PREFS->{"lastdir"},
                  -selectmode => 'multiple',
                  '-accept' => 
                  sub{
                      $file = shift;
                      return ($file =~
                              /\.(pdb|prc|pqa)$/i &&
                              -f $file);
                  });

    my $gFileSelector;
    if ($Tk::version == 4.0) {
        $gFileSelector = $gWm->MultiFileSelect(@params);
    } else {
        $gFileSelector = $gWm->FileSelect(@params);
    }

    if (scalar(@files = $gFileSelector->Show) && defined($files[0])) {
        my ($tmp);

        # Jump through some hoops to compress the directory
        # path down from "/a/b/D/../../c" to "/a/c"
        #
        $PREFS->{"lastdir"} = $gFileSelector->cget(-directory);
        chomp($tmp = Cwd::cwd() || Cwd::fastcwd() || `pwd`);
        Cwd::chdir($PREFS->{"lastdir"});
        chomp($PREFS->{"lastdir"} = Cwd::cwd() || Cwd::fastcwd() || `pwd`);
        chdir($tmp);

        for ($tmp=$[; $tmp < @files; $tmp++) {
            $file = $files[$tmp];

            if ($file =~ m|/\*$|) {
                # copy all prc/pdb/pqa files from a dir:
                opendir FOO, dirname($file);
                push(@files, map($_ = dirname($file) . "/$_",
                                 grep(/\.(prc|pdb|pqa)$/i, readdir FOO)));
                closedir FOO;
                next;
            }

#             # copying to a dir not supported by File::Copy in perl 5.003,
#             # so append basename of file:
#             unless (copy($file, "$RCDIR/" . basename($file)))
#             {
#                 print("Error copying $file to $RCDIR ($!)");
#             }
        }
    }


    print "you selected: " . join("\n",@files) . "\n";
}


$gWm->Button(-text    => "start me up",
             -command => \&btnCallback)->pack(qw/-side top -anchor w/);

MainLoop;
