#! /usr/bin/env perl

use strict;
use warnings;

use SAPO::Broker::Clients::Simple;
use Data::Dumper;

my $destination = '/my/own/business';
#my $destination = '/my_treta/';
my %server = (
    public  => 'broker.labs.sapo.pt',
    boxed   => '127.0.0.1',
    default => $ENV{PUBLIC_SAPO_BROKER_AGENT},
);
my %options = (
                'destination_type' => 'QUEUE',
                'destination'      => $destination,
);

print "CONNECTING...\n";
my $broker =
  SAPO::Broker::Clients::Simple->new( host => $server{default} )
  or die "Cant connect? CAUSE: $@\n";

# Consuming
print "SUBSCRIBING...\n";
$broker->subscribe( %options, auto_acknowledge => 1 )
  ;    #auto_acknowledge makes life simpler
print "RECEIVING...\n";
while ( 1 ) {
    my $notification = $broker->receive;
    my $payload      = $notification->message->payload;

    print "Message received: ", Dumper $payload;
} ## end while ( 1 )
