package SagasuApp;

use strict;
use warnings;

use Mojo::Base 'Mojolicious';
use SagasuApp::Model::Schema;

# This method will run once at server start
sub startup {
    my $self = shift;


    $self->plugin(
        'Config', { file => $self->app->home->rel_file( 'etc/sagasu.conf' ) }
    );
    $self->plugin(
        'Config', { file => $self->app->home->rel_file( 'etc/secret.conf' ) }
    );

    # Schema
    my $mysql = $self->config->{ mysql };
    $self->helper( 
        'schema' => 
            sub { SagasuApp::Model::Schema->connect( 
                "dbi:mysql:$mysql->{ database }",
                $mysql->{ user },
                $mysql->{ password }, 
                { mysql_enable_utf8 => 1 } 
            ) 
        } 
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
    
    $admin->get( '/admin/category' )->to( 'admin-category#index' );
    $admin->any( '/admin/category/add' )->to( 'admin-category#add' );
    $admin->any( '/admin/category/edit' )->to( 'admin-category#edit' );
    $admin->any( '/admin/category/delete' )->to( 'admin-category#delete' );

    $admin->get( '/admin/log' )->to( 'admin-log#index' );
    $admin->get( '/admin/log/remove' )->to( 'admin-log#remove' );
}

1;
