use Test;
use IPC::Run3;
use strict;

my ( $in, $out, $err ) = @_;

my @tests = (
sub {
    eval { run3 };
    ok $@;
},

sub {
    ( $in, $out, $err ) = ();
    run3 [$^X, '-e', 'print "OUT"' ], \undef, \$out, \$err;
    ok $out, "OUT";
},

sub {
    ok $err, "";
},

sub {
    ( $in, $out, $err ) = ();
    run3 [$^X, '-e', 'print map uc, <>' ], \"in", \$out, \$err;
    ok $out, "IN";
},

sub {
    ok $err, "";
},

sub {
    ( $in, $out, $err ) = ();
    run3 [$^X, '-e', 'print STDERR map uc, <>' ], \"in", \$out, \$err;
    ok $out, "";
},

sub {
    ok $err, "IN";
},

sub {
    ( $in, $out, $err ) = ();
    run3 [$^X, '-e', 'print map uc, <>' ], [qw( in1 in2 )], \$out;
    ok $out, "IN1IN2";
},

sub {
    ( $in, $out, $err ) = ();
    run3 [$^X, '-e', 'print map ".".uc, <>' ], \"in1\nin2", \$out;
    ok $out, ".IN1\n.IN2";
},

sub {
    ( $in, $out, $err ) = ();
    my @in = qw( in1 in2 );
    run3 [$^X, '-e', 'print map uc, <>' ], sub { shift @in }, \$out;
    ok $out, "IN1IN2";
},

sub {
    ( $in, $out, $err ) = ();
    my @in = qw( in1 in2 );
    run3 [$^X, '-e', '$|=1; for (<>){print uc;print STDERR lc}' ],
        \"in1\nin2\n", \$out,\$out;
    ok $out, "IN1\nin1\nIN2\nin2\n";
},

sub {
    my $fn = "t/test.txt";
    unlink $fn or warn "$! unlinking $fn" if -e $fn;

    ( $in, $out, $err ) = ();
    run3 [$^X, '-e', 'print "OUT"' ], \undef, $fn;
    ok -s $fn, 3;
},
);

plan tests => 0+@tests;

$_->() for @tests;
