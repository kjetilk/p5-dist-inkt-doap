package Dist::Inkt::Role::AddExternalRDF;

our $AUTHORITY = 'cpan:KJETILK';
our $VERSION   = '0.100';

use Moose::Role;
use namespace::autoclean;
use RDF::Trine::Parser;
use Path::Tiny;

with 'Dist::Inkt::Role::RDFModel';

after PopulateModel => sub {
  my $self = shift;

  my $justaddfile = path($ENV{'DIST_INKT_ADD_DATA'} || "~/.dist-inkt-data.ttl");
  my $filteredfile = path($ENV{'DIST_INKT_FILTERED_DATA'} || "~/.dist-inkt-filtered-data.ttl");
  my $base_uri = sprintf('http://purl.org/NET/cpan-uri/dist/%s/', $self->name);

  if ($justaddfile->is_file) {
	 $self->log('Reading %s', $justaddfile);
	 
	 my $p = RDF::Trine::Parser->guess_parser_by_filename($justaddfile->basename);
	 $p->parse_file_into_model($base_uri, $justaddfile->filehandle, $self->model);
  }
  
  if ($filteredfile->is_file) {
	 $self->log('Reading %s', $filteredfile);
	 my %resources;
	 my $iter = $self->model->as_stream;
	 while (my $st = $iter->next) {
		if ($st->subject->is_resource) {
		  $resources{$st->subject->uri_value} = 1;
		}
		if ($st->predicate->is_resource) {
		  $resources{$st->predicate->uri_value} = 1;
		}
		if ($st->object->is_resource) {
		  $resources{$st->object->uri_value} = 1;
		}
	 }
	 my $proto = RDF::Trine::Parser->guess_parser_by_filename($filteredfile->basename);
	 my $p = $proto->new;
	 my $handler = sub {
		my $st = shift;
		if ($resources{$st->subject->uri_value}) {
		  $self->model->add_statement( $st );
		}
	 };
	 $p->parse_file($base_uri, $filteredfile->filehandle, $handler);
  }
  
};

1;
