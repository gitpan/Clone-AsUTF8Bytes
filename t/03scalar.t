# $Id: 03scalar.t,v 0.19 2006/10/08 03:37:29 ray Exp $
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

my $has_data_dumper;
BEGIN {
  $| = 1;
  my $tests = 8;
  eval q[use Data::Dumper];
  if (!$@) {
    $has_data_dumper = 1;
    $tests++;
  }
  print "1..$tests\n";
}
END {print "not ok 1\n" unless $loaded;}
use Clone::AsUTF8Bytes qw( clone_as_utf8_bytes );
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

package Test::Scalar;

use vars @ISA;

@ISA = qw(Clone::AsUTF8Bytes);

sub new
  {
    my $class = shift;
    my $self = shift;
    bless \$self, $class;
  }

sub DESTROY 
  {
    my $self = shift;
    # warn "DESTROYING $self";
  }

package main;

sub ok     { print "ok $test\n"; $test++ }
sub not_ok { print "not ok $test\n"; $test++ }

$^W = 0;
$test = 2;

my $a = Test::Scalar->new(1.0);
my $b = $a->clone_as_utf8_bytes(1);

$$a == $$b ? ok : not_ok;
$a != $b ? ok : not_ok;

my $c = \"test 2 scalar";
my $d = Clone::AsUTF8Bytes::clone_as_utf8_bytes($c, 2);

$$c == $$d ? ok : not_ok;
$c != $d ? ok : not_ok;

my $circ = undef;
$circ = \$circ;
$aref = clone_as_utf8_bytes($circ);
if ($has_data_dumper) {
  Dumper($circ) eq Dumper($aref) ? ok : not_ok;
}

# the following used to produce a segfault, rt.cpan.org id=2264
undef $a;
$b = clone_as_utf8_bytes($a);
$$a == $$b ? ok : not_ok;

# used to get a segfault cloning a ref to a qr data type.
my $str = 'abcdefg';
my $qr = qr/$str/;
my $qc = clone_as_utf8_bytes( $qr );
$qr eq $qc ? ok : not_ok;
$str =~ /$qc/ ? ok : not_ok;
