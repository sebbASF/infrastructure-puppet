#!/usr/bin/perl

#  setlock.pl Execute command while holding exclusive lock
#  Defaults to waiting 10 minutes for the lock
#  Usage:  setlock.pl /path/to/lockfile $command @args

=head1 NOTICE TO MAINTAINERS

Change C<puppet:modules/mail_archives/files/scripts/setlock.pl> and not this file directly.

=cut

use strict;
use warnings FATAL => 'all';
use Fcntl ":flock";

my $timeout = $ENV{TIMEOUT} || 600; # 10 minutes

my ($lockfile, $command, @args) = @ARGV;

die "Usage: $0 /path/to/lockfile command args"
    unless $lockfile and $command;

open my $fh, "+>>", $lockfile or die "Can't open lockfile $lockfile: $!";
eval {
    local $SIG{ALRM} = sub { die "Timeout waiting for lock ($timeout)" };
    alarm $timeout;
	flock $fh, LOCK_EX or die "Can't get exclusive lock on $lockfile: $!";
    alarm 0;
};
die "$@\n" if ($@);

# Lock granted, execute the command
exit system $command, @args;

