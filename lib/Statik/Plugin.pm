# Base class for statik plugins

package Statik::Plugin;

use strict;
use Carp;
use Hash::Merge qw(merge);

sub new {
  my ($class, %arg) = @_;
  my $self = bless {}, ref $class || $class;

  # Check arguments
  $self->{config} = delete $arg{config} 
    or croak "Required argument 'config' missing";
  croak "Invalid arguments: " . join(',', sort keys %arg) if %arg;

  # Initialise
  $self->{name} = ref $self;
  my $plugin_config = merge( $self->{config}->{$self->{name}}||{}, $self->defaults );
  for (qw(config name)) {
    die "Can't use reserved attribute '$_' as $self->{name} config item"
      if exists $plugin_config->{$_};
  }
  $self->{$_} = $plugin_config->{$_} foreach keys %$plugin_config;

  $self;
}

# Plugin config defaults
sub defaults {
  return {};
}

1;