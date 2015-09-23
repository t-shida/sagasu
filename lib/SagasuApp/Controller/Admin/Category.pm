package SagasuApp::Controller::Admin::Category;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';

sub index {
    my $self = shift;

    my $schema = $self->schema;
    my $category_rs = $schema->resultset( 'Category' );
    my @category = $category_rs->search( { 
        status => $self->config->{ status }->{ active } 
    } );
    $self->stash->{ category } = \@category;

    $self->render;
}

sub add {
    my $self = shift;

    if ( $self->req->method eq 'GET' ) {
        return $self->render( error => '' );
    } 
    elsif ( $self->req->method eq 'POST' ) {
        my $category = $self->param( 'category' ); 

        return $self->render( error => 'category is empty' ) if ! $category;

        my $schema = $self->schema;

        my $category_rs = $schema->resultset( 'Category' );
        my @category = $category_rs->search( {  label => $category } );
        return $self->render( error => "$category is exists" ) if @category;

        $category_rs->create( { 
            status => $self->config->{ status }->{ active }, 
            label => $category 
        } );

        return $self->redirect_to( '/admin/category' );
    }
    else {
        return $self->render_not_found;
    }
}

sub edit {
    my $self = shift;

    my $id = $self->param( 'id' ) + 0 || return $self->render_not_found;
    $self->stash->{ id } = $id;

    my $category_rs = $self->schema->resultset( 'Category' );
    my $category = $category_rs->find( $id );
    return $self->render_not_found if ! $category;

    if ( $self->req->method eq 'GET' ) {
        $self->stash->{ category } = $category->label;
        $self->stash->{ error } = '';
        return $self->render;
    }
    elsif ( $self->req->method eq 'POST' ) {
        my $category_update = $self->param( 'category' );

        if ( ! $category_update ) {
            $self->stash->{ category } = '';
            $self->stash->{ error } = 'category is empty';
            return $self->render;
        }

        my @category = $category_rs->search( { 
            id => { '!=' => $id }, label => $category_update 
        } );
        if ( @category ) {
            $self->stash->{ category } = $category_update;
            $self->stash->{ error } = "$category_update is exists";
            return $self->render;
        }

        $category->label( $self->param( 'category' ) );
        $category->update;
        return $self->redirect_to( '/admin/category' );
    }
    else {
        return $self->render_not_found;
    }
}

sub delete {
    my $self = shift;

    my $id = $self->param( 'id' ) + 0 || return $self->render_not_found;
    $self->stash->{ id } = $id;

    my $category_rs = $self->schema->resultset( 'Category' );
    my $category = $category_rs->find( $id );
    return $self->render_not_found if ! $category;

    if ( $self->req->method eq 'GET' ) {
        $self->stash->{ category } = $category->label;
        $self->stash->{ error } = '';
        return $self->render;
    }
    elsif ( $self->req->method eq 'POST' ) {
        $category->delete;
        return $self->redirect_to( '/admin/category' );
    }
    else {
        return $self->render_not_found;
    }
}

1;
