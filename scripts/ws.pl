use utf8;

use Mojolicious::Lite;
use Mojo::JSON;

use JspellExec;
use crud;
use git;

use Encode qw(decode encode);

my $json;

sub init {
	
  	$json  = Mojo::JSON->new;
}

######
#
# Methods to lead with jquery 
#
######

  # GET /manager/load.json?id=default
  get  '/manager/load' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $id = $self->param('id');

    my $branch;

    if( $id eq 'default' || !defined $id ) {
        $branch = 'default';
    } else {
        $branch = $id;
    }

    

    # my $str = query_singleton("../out/jspell-ao/", $entrada);
    my $str = JspellExec::query_singleton("../out/jspell-ao/", $entrada);

    my $hash = $json->decode($str);

    return $self->render(json => $hash) if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };


  # GET /jspell/flex.json?entry=abismal%2F%23an%2Fp%2F
  get  '/jspell/flex' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $entrada = $self->param('entry');

    # my $str = query_singleton("../out/jspell-ao/", $entrada);
    my $str = JspellExec::query_singleton("../out/jspell-ao/", $entrada);

    my $hash = $json->decode($str);

    return $self->render(json => $hash) if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };

  # GET /jspell/retrive.json?lexeme=casa
  get  '/jspell/retrive' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $palavra = $self->param('palavra');
    my $str = JspellExec::query_default("../out/jspell-ao/", "teste", $palavra);
    my $hash = $json->decode($str);

    return $self->render(json => $hash) if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };

init();  
app->start;


