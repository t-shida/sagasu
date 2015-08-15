package SagasuApp::Controller::Admin::Log;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';
use IO::File;

sub index {
    my $self = shift;
    my $io = IO::File->new(
        $self->app->home->rel_file( $self->config->{ log_file } 
    ), 'r') or die $!;
    my @log = $io->getlines;
    $io->close;

    $self->stash->{ log } = \@log;

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
