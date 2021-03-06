package URI::Afthon::ItemSearch;

use strict;
use warnings;
use utf8;
use open OUT => qw/:utf8 :std/;

our $VERSION = '0.01';

use WebService::Rakuten;
use Hash::Merge qw( merge );
use XML::Simple;
use YAML::Syck;
use LWP::UserAgent;
use Carp;
use Data::Dumper;
use Log::Minimal;
use base 'URI::https';

$ENV{LM_DEBUG} = 1;

sub new {
  my ($class, %options) = @_;

  my $self = {
      applicationId => '1055373245759610331',
      format => 'xml',
      %options,
  };

  bless $self, $class;
}

sub search {
    my ($self, %params) = @_;

    my %query_params = (
        applicationId => $self->{applicationId},
        format => $self->{format},
        affiliateId => '11068980.9df881e7.11068981.510ea67c',
        %params,
    );

    $self->_request(\%query_params);

    if ($self->{page_count} > 1) {
        my $page = $self->{page_count};

        if ($page > 1) {
            for (my $i = 2; $i <= $page; $i++) {
                $query_params{page} = $i;
                $self->_request(\%query_params);
            }
        }
    }
}

sub _request {
    my ($self, $query_params_ref) = @_;

    my $ua = LWP::UserAgent->new;
    my $u = $self->_make_request_uri($query_params_ref);
    my $r = $ua->get($u);

    if ($r->is_success) {
        my $content = XMLin(
            $r->content,
            ForceArray => ['Item', 'Error', 'mediumImageUrls', 'smallImageUrls'],
        );

        $self->{page_count} = $content->{pageCount} + 0;

        if (exists $self->{item_list}) {
            my $merged_item_list = merge($self->{item_list}, $content->{Items});
            $self->{item_list} = $merged_item_list;
        } else {
            $self->{item_list} = $content->{Items};
        }
    } else {
        warnf($r->status_line, $r->as_string, $r->message());
        carp "parse error";
    }
}

sub _make_request_uri {
    my ($self, $query_params_ref) = @_;
    my $u = URI->new('https://app.rakuten.co.jp/services/api/IchibaItem/Search/20120723');

    ref $u eq 'URI::https' or carp "must be https";

    $u->query_form($query_params_ref);

    return $u;
}

1;

