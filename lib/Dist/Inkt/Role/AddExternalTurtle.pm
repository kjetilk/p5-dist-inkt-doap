package Dist::Inkt::Role::AddExternalTurtle;

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

  my $ap = RDF::Trine::Parser->guess_parser_by_filename($justaddfile->basename);
  my $base_uri = sprintf('http://purl.org/NET/cpan-uri/dist/%s/', $self->name);
  $ap->parse_file_into_model($base_uri, $justaddfile->filehandle, $self->model);
								  
								  

};

1;
