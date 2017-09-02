#! perl -w
use strict;
use Test::More;

use Dancer::RPCPlugin::DispatchMethodList;

{
    my $l = Dancer::RPCPlugin::DispatchMethodList->new();
    isa_ok($l, 'Dancer::RPCPlugin::DispatchMethodList');

    $l->set_partial(
        protocol => 'jsonrpc',
        endpoint => '/customer',
        methods  => [qw/get_user update_user remove_user/],
    );

    my $jsonrpc = $l->list_methods({protocol => 'jsonrpc'});
    is_deeply(
        $jsonrpc,
        {
            '/customer' => [qw/get_user update_user remove_user/],
        },
        "list_methods(jsonrpc)"
    );

    my $all = $l->list_methods();
    is_deeply(
        $all,
        {
            jsonrpc => {
                '/customer' => [qw/get_user update_user remove_user/],
            }
        },
        "list_methods()"
    );
}

{ # It's a singleton => the previous values should stick.
    my $l = Dancer::RPCPlugin::DispatchMethodList->new();
    isa_ok($l, 'Dancer::RPCPlugin::DispatchMethodList');

    $l->set_partial(
        protocol => 'xmlrpc',
        endpoint => '/customer',
        methods  => [qw/get_user update_user remove_user/],
    );

    my $xmlrpc = $l->list_methods({protocol => 'xmlrpc'});
    is_deeply(
        $xmlrpc,
        {
            '/customer' => [qw/get_user update_user remove_user/],
        },
        "list_methods(xmlrpc)"
    );

    my $all = $l->list_methods();
    is_deeply(
        $all,
        {
            jsonrpc => {
                '/customer' => [qw/get_user update_user remove_user/],
            },
            xmlrpc => {
                '/customer' => [qw/get_user update_user remove_user/],
            },
        },
        "list_methods()"
    );
}

done_testing();
