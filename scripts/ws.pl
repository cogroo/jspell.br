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

    git::new_branch($branch);
    git::make($branch);

    my $path = git::get_branch_path('default') . 'out/jspell-ao/';
    JspellExec::install($path, $id);

    return $self->render(json => '1') if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };

  # GET /manager/branch.json?id=mybranch
  get  '/manager/branch' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $id = $self->param('id');

    my $branch;

    if( $id eq 'default' || !defined $id ) {
        return $self->render(json => '0') if $self->stash('format') eq 'json';
    } else {
        $branch = $id;
    }

    git::new_branch($branch);
    git::make($branch);

    my $path = git::get_branch_path('default') . 'out/jspell-ao/';
    JspellExec::install($path, $id);

    return $self->render(json => '1') if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };

  # GET /manager/commit.json?id=mybranch&message=a_message
  get  '/manager/commit' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $id = $self->param('id');
    my $message = $self->param('message');

    my $branch;

    if( $id eq 'default' || !defined $id ) {
        return $self->render(json => '0') if $self->stash('format') eq 'json';
    } else {
        $branch = $id;
    }

    git::commit($branch, $message);

    return $self->render(json => '1') if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };

  # GET /manager/push.json?id=mybranch
  get  '/manager/push' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $id = $self->param('id');

    my $branch;

    if( $id eq 'default' || !defined $id ) {
        return $self->render(json => '0') if $self->stash('format') eq 'json';
    } else {
        $branch = $id;
    }

    git::push_to_git($branch);

    return $self->render(json => '1') if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };


  # GET /jspell/flex.json?entry=abismal%2F%23an%2Fp%2F
  get  '/jspell/flex' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $entrada = $self->param('entry');

    # my $str = query_singleton("../out/jspell-ao/", $entrada);
    my $path = git::get_branch_path('default') . 'out/jspell-ao/';
    my $str = JspellExec::query_singleton($path, $entrada);

    my $hash = $json->decode($str);

    return $self->render(json => $hash) if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };

  # GET /jspell/analyse.json?id=default&lexeme=casa
  get  '/jspell/analyse' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $palavra = $self->param('lexeme');
    my $id = $self->param('id');
    
    my $branch;

    if( $id eq 'default' || !defined $id ) {
        $branch = 'default';
    } else {
        $branch = $id;
    }
    my $path = git::get_branch_path($id) . 'out/jspell-ao/';
    print "Path: " . $path . "\n";
    my $str = JspellExec::query_default($path, $id, $palavra);
    my $hash = $json->decode($str);

    return $self->render(json => $hash) if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };

init();  
app->start;


