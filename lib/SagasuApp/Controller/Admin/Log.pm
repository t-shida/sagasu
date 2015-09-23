package SagasuApp::Controller::Admin::Log;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';
use SagasuApp::Model::Schema;
use IO::File;
use Data::Dumper;

sub index {
    my $self = shift;
    my $io = IO::File->new(
        $self->app->home->rel_file( $self->config->{ log_file } 
    ), 'r') or die $!;
    my @log = $io->getlines;
    $io->close;

    $self->stash->{ log } = \@log;

    #my $schema = SagasuApp::Model::Schema->connect( 'dbi:mysql:sagasu', 'root', 'root' );
    #my $category_rs = $schema->resultset( 'Category' );
    #$category_rs->create( { title => 'book' } );
    #my $category = $category_rs->find( 2 );

    $self->render;
}

sub remove {
    my $self = shift;

    my $io = IO::File->new(
        $self->app->home->rel_file( $self->config->{ log_file } ), "w"
    );
    $io->print('');
    $io->close;

    $self->redirect_to( '/admin/log' );
}


1;
