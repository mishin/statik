# Name: Statik::Plugin::Markdown
# Author(s): Gavin Carr <gavin@openfusion.com.au>
# Version: 0.001
# Documentation: see bottom of file or type 'perldoc Statik::Plugin::Markdown'

package Statik::Plugin::Markdown;

use strict;
use parent qw(Statik::Plugin);
use Text::Markdown qw(markdown);

# -------------------------------------------------------------------------
# Configuration defaults. To change, add a [Statik::Plugin::Markdown]
# section to your statik.conf config, and update as key = value entries.

sub defaults {
  return {
    # Flag indicating whether all posts will be in markdown format
    all_posts_are_markdown => 0,
  };
}

# -------------------------------------------------------------------------

sub start {
  my $self = shift;
  $self->{markup} = Text::Markdown->new(
    tab_width => 0,
  ) or die "Text::Markdown instantiation failed: $!";
}

sub post {
  my ($self, %arg) = @_;
  my $stash = $arg{stash};
  if ($self->{all_posts_are_markdown}) {
    $self->_munge_template(template => \$stash->{body}, stash => $stash);
    $self->_munge_template(template => \$stash->{body_unesc}, stash => $stash);
  }
}

sub _munge_template {
  my ($self, %arg) = @_;
  my $template_ref = $arg{template};
  $$template_ref = markdown $$template_ref;
}

1;

__END__

=head1 NAME

Statik::Plugin::Markdown - adds support for posts written in markdown

=head1 DESCRIPTION

Statik::Plugin::Markdown - adds support for posts formatted in markdown,
using the Text::Markdown perl module.

=head1 CONFIGURATION

To configure, add a section like the following to your statik.conf file
(defaults shown):

    [Statik::Plugin::Markdown]
    all_posts_are_markdown = 0


=head1 SEE ALSO

L<Text:::Markdown>

=head1 AUTHOR

Gavin Carr <gavin@openfusion.com.au>, http://www.openfusion.net/

=head1 LICENCE

Copyright 2011-2013, Gavin Carr.

This software is free software, licensed under the same terms as perl itself.

=cut

# vim:ft=perl

