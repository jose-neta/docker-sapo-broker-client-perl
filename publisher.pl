#! /usr/bin/env perl

use strict;
use warnings;
use JSON;

use SAPO::Broker::Clients::Simple;

my $destination = '/my/own/business';
my %server = (
    public => 'broker.labs.sapo.pt',
    boxed => '127.0.0.1',
    default          => $ENV{PUBLIC_SAPO_BROKER_AGENT},
);
my %options = (
    destination_type => 'QUEUE',
    destination      => $destination,
);

print "CONNECTING...\n";
my $broker =
  SAPO::Broker::Clients::Simple->new( host => $server{default} )
  or die "Cant connect? CAUSE: $@\n";
my $payload = {
             some       => 10,
             thing      => 'with',
             profile    => {
                 other => ["things:salter:'or_not'"]
             },
};

print "SENDING...\n";
eval {
    #$broker->publish( %options, payload => to_json $payload );
    $broker->publish( %options, payload => 'textosss' );
};
print STDERR "Erro no broker: $@\n" if $@;

