package Dist::Inkt::Role::AddExternalTurtle;

our $AUTHORITY = 'cpan:KJETILK';
our $VERSION   = '0.100';

use Moose::Role;
use namespace::autoclean;
use RDF::Trine;

with 'Dist::Inkt::Role::RDFModel';

after PopulateModel => sub {
  my $self = shift;

  my $justaddfile = $ENV{'DIST_INKT_ADD_TURTLE') || $ENV{'HOME'} . '/.dist-inkt-data.ttl';
  my $filteredfile = $ENV{'DIST_INKT_FILTERED_TURTLE') || $ENV{'HOME'} . '/.dist-inkt-filtered-data.ttl';

  my $addstring = $self->open_and_fix($justaddfile) if (-r $justaddfile);
  
  
        {

                 
                $self->log('Reading %s', $file);
                $file =~ /\.pret$/
                        ? do {
                                require RDF::TrineX::Parser::Pretdsl;
                                parse($file, into => $self->model, using => 'RDF::TrineX::Parser::Pretdsl'->new)
                        }: parse($file, into => $self->model);
        }
};

sub open_and_fix {
  my ($self, $file) = @_;
  
  open (my $fh, '<', $file) || $self->log("Couldn't open $file");
  
		 
1;
