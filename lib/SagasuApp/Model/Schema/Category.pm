package SagasuApp::Model::Schema::Category;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( qw( PK::Auto::MySQL Core ) );
__PACKAGE__->table( 'category' );

__PACKAGE__->add_columns(
    id => {
        accessor  => 'category',
        data_type => 'integer',
        size      => 16,
        is_nullable => 0,
        is_auto_increment => 1,
        default_value => '',
    },
    status => {
        data_type => 'integer',
        is_nullable => 0,
    },
    label  => {
        data_type => 'varchar',
        size      => 255,
        is_nullable => 0,
        is_auto_increment => 0,
        default_value => '',
    }
);

__PACKAGE__->set_primary_key( 'id' );

1;
