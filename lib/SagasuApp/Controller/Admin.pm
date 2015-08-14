package SagasuApp::Controller::Admin;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';

sub login {
  my $self = shift;

  return 1 if $self->session( 'admin' );

  my $user = $self->config->{ admin_user };
  my $email = $self->param( 'email' );
  my $password = $self->param( 'password' );
  if ( $email eq $user->{ email } && $password eq $user->{ password } ) {
    $self->session( admin => 1 );
    $self->redirect_to( '/admin' );
  }

  $self->render;
}

sub auth {
  my $self = shift;

  $self->redirect_to( '/admin' ) if $self->session( 'admin' );

  my $user = $self->config->{ admin_user };
  my $email = $self->param( 'email' );
  my $password = $self->param( 'password' );
  if ( $email eq $user->{ email } && $password eq $user->{ password } ) {
    $self->session( admin => 1 );
    $self->session->store;
    $self->redirect_to( '/admin' );
  }

  $self->redirect_to( '/admin/login' );
}

sub index {
  my $self = shift;

  $self->stash->{ msg } = 'index';
  $self->render;
}

1;
