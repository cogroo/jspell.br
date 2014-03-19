use utf8;

use Mojolicious::Lite;
use Mojo::JSON;

use JspellExec;

use Encode qw(decode encode);

my $json;

sub init {
	
  	$json  = Mojo::JSON->new;
}

  # GET /query.json?palavra=casa
  get '/query' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $palavra = $self->param('palavra');
    my $str = JspellExec::query_default("../out/jspell-ao/", "teste", "casa");
    my $hash = $json->decode($str);

    return $self->render(json => $hash) if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };

  # GET /process.json?entrada=abismal%2F%23an%2Fp%2F&id=teste
  get '/process' => [format => [qw(json)]] => sub {
    my $self = shift;

    my $entrada = $self->param('entrada');
    my $id = $self->param('id');
    print $entrada . "\n";
    print $id . "\n";
    my $str = JspellExec::query_singleton("../out/jspell-ao/", $id, $entrada);
    my $hash = $json->decode($str);

    return $self->render(json => $hash) if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };

init();  
app->start;


