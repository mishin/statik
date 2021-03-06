package Statik::Test::Util;

use strict;
use warnings;
use Exporter::Lite;
use DateTime::Format::Strptime;
use File::Spec;
use File::stat;

our @EXPORT = qw();
our @EXPORT_OK = qw(check_timestamps);

# Check for any timestamp.* symlinks in the given directory and
# update the mtime timestamps of their targets
sub check_timestamps {
  my ($dir, $strptime) = @_;
  $strptime ||= '%Y-%m-%dT%T';

  my $strp = DateTime::Format::Strptime->new(
    pattern     => $strptime,
    on_error    => 'croak',
  );

  for my $ts_file (glob("$dir/timestamp.*")) {
    next unless -l $ts_file;
    (my $ts = $ts_file) =~ s!^$dir/timestamp\.!!;
    my $t = $strp->parse_datetime($ts);

    my $target = File::Spec->rel2abs(readlink $ts_file, $dir);
    unless (-e $target) {
      warn "$ts target '$target' not found - skipping\n";
      next;
    }

    my $touch_ts = $t->strftime("%Y%m%d%H%M.%S");
    system("touch -t $touch_ts $target") == 0
      or die "Touch on $target failed: $!";

    Test::More::is(stat($target)->mtime, $t->epoch, "mtime of $target ok");
  }
}

1;

