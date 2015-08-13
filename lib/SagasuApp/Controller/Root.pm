package SagasuApp::Controller::Root;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';

sub index {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render( msg => 'Sagasu' );
}

1;
