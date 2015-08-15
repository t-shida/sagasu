package SagasuApp;

use strict;
use warnings;

use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
    my $self = shift;

    # Documentation browser under "/perldoc"
    #$self->plugin('PODRenderer');

    $self->plugin(
        'Config', { file => $self->app->home->rel_file( 'etc/sagasu.conf' ) }
    );
        $self->plugin(
        'Config', { file => $self->app->home->rel_file( 'etc/auth.conf' ) }
    );

    # Router
    my $r = $self->routes;

    $r->get( '/' )->to('root#index');

    # admin
    my $admin = $r->under->to( 'admin-root#login' );
    $admin->post( '/admin' )->to( 'admin-root#login' );
    $admin->get( '/admin' )->to( 'admin-root#index' );
    $admin->get( '/admin/login' )->to( 'admin-root#login' );
    $admin->get( '/admin/logout' )->to( 'admin-root#logout' );
    
    $admin->get( '/admin/log' )->to( 'admin-log#index' );
    $admin->get( '/admin/log/remove' )->to( 'admin-log#remove' );
}

1;
