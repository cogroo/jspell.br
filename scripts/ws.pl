use utf8;

use Mojolicious::Lite;
use Mojo::JSON;

use JspellExec;
use crud;
use git;
use Data::Dumper;

use Encode qw(decode encode);

my $json;

sub init {
	
  	$json  = Mojo::JSON->new;
}

######
# Argumento obrigatório em todos: passwd (ainda não validado)
#
#
# manager/ 
#   load [id]: cria o repositório default ou um de nome 'id' e o prepara para consultas
#   reload [id]: recarrega o dicionário padrão ou o do branch 'id', permitindo consultas
#   commit id message:  faz commit das alterações em 'id' incluindo uma mensagem 'message'
#   push id: envia as alterações em 'id' para o Github e deleta o repositório
#   delete id: deleta o repositório com id
#   
#
# jspell/
#   try [entry]: faz a analise e e flexoes da entrada
#   analyse [id] lexeme: analisa o lexeme usando o repositório 'id'
#
# editor/
#    create id category entry: cria a entrada "entry" na categoria "category" no repositório "id"
#    update id category entry_before entry_after: altera a "entry_before" para "entry_before" na categoria especificada, no repositorio especificado
#    delete id category entry: elimina a entrada "entry" da categoria "category" do repositorio "id"
#    retrieve id lemma: busca as ocorrencias do lema "lemma" no repositorio "id", devolve as categorias e as entradas em cada categoria#   
#
######

##
# Editor
##

 #  GET /editor/create.json?id=mybranch&category=inf&entry=orkut%2F%23nm%2F%2F
  get  '/editor/create' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $id = $self->param('id');
    my $category = $self->param('category');
    my $entry = $self->param('entry');


    if( $id eq 'default' || !defined $id ) {
        return $self->render(json => {status => 'NOT OK', message => "Impossível editar repositório default."}) if $self->stash('format') eq 'json';
    }

    if( !defined $category || !defined $entry ) {
        return $self->render(json => {status => 'NOT OK', message => "category e entry são obrigatórios."}) if $self->stash('format') eq 'json';
    }

    eval {
      my $path = git::get_branch_path($id);
      crud::create($path, $category, $entry);

      git::make($id);
      JspellExec::install($path . 'out/jspell-ao/', $id);
    };

    if ($@) {
      warn "NOT OK: $@";
      return $self->render(json => {status => 'NOT OK', message => $@}) if $self->stash('format') eq 'json';
    };

    return $self->render(json => {status => 'OK', message => "Criou $entry na categoria $category no repositório $id. Pronto para consultas."}) if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };


 #  GET /editor/update.json?id=mybranch&category=inf&entry_before=bug%2F%23nm%2CORIG%3Ding%2Fa%2F&entry_after=bug%2F%23nm%2CORIG%3Ding%2Fxyz%2F
  get  '/editor/update' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $id = $self->param('id');
    my $category = $self->param('category');
    my $entry_before = $self->param('entry_before');
    my $entry_after = $self->param('entry_after');


    if( $id eq 'default' || !defined $id ) {
        return $self->render(json => {status => 'NOT OK', message => "Impossível editar repositório default."}) if $self->stash('format') eq 'json';
    }

    if( !defined $category || !defined $entry_before || !defined $entry_after) {
        return $self->render(json => {status => 'NOT OK', message => "category, entry_before e entry_after são obrigatórios."}) if $self->stash('format') eq 'json';
    }

    eval {
      my $path = git::get_branch_path($id);
      crud::update($path, $category, $entry_before, $entry_after);

      git::make($id);
      JspellExec::install($path . 'out/jspell-ao/', $id);
    };

    if ($@) {
      warn "NOT OK: $@";
      return $self->render(json => {status => 'NOT OK', message => $@}) if $self->stash('format') eq 'json';
    };

    return $self->render(json => {status => 'OK', message => "Atualizou $entry_before para $entry_after na categoria $category no repositório $id. Pronto para consultas."}) if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };


 #  GET /editor/delete.json?id=mybranch&category=abrev&entry=etc%2FABR%3D1%2F%2F
  get  '/editor/delete' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $id = $self->param('id');
    my $category = $self->param('category');
    my $entry = $self->param('entry');


    if( $id eq 'default' || !defined $id ) {
        return $self->render(json => {status => 'NOT OK', message => "Impossível editar repositório default."}) if $self->stash('format') eq 'json';
    }

    if( !defined $category || !defined $entry ) {
        return $self->render(json => {status => 'NOT OK', message => "category e entry são obrigatórios."}) if $self->stash('format') eq 'json';
    }

    eval {
      my $path = git::get_branch_path($id);
      crud::DELETE($path, $category, $entry);

      git::make($id);
      JspellExec::install($path . 'out/jspell-ao/', $id);
    };

    if ($@) {
      warn "NOT OK: $@";
      return $self->render(json => {status => 'NOT OK', message => $@}) if $self->stash('format') eq 'json';
    };

    return $self->render(json => {status => 'OK', message => "Excluiu $entry na categoria $category no repositório $id. Pronto para consultas."}) if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };


#  GET /editor/retrieve.json?id=mybranch&lemma=%C3%A1guia-imperial
  get  '/editor/retrieve' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $id = $self->param('id');
    my $category = $self->param('category');
    my $lemma = $self->param('lemma');


    if( $id eq 'default' || !defined $id ) {
        return $self->render(json => {status => 'NOT OK', message => "Impossível editar repositório default."}) if $self->stash('format') eq 'json';
    }

    if( !defined $lemma ) {
        return $self->render(json => {status => 'NOT OK', message => "lemma é obrigatório."}) if $self->stash('format') eq 'json';
    }

    my %res;
    eval {
      my $path = git::get_branch_path($id);
      %res = crud::retrieve_lemma($path, $lemma);
    };

    if ($@) {
      warn "NOT OK: $@";
      return $self->render(json => {status => 'NOT OK', message => $@}) if $self->stash('format') eq 'json';
    };

    return $self->render(json => \%res) if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };

##
# Manager
##

  # GET /manager/load.json?id=mybranch
  get  '/manager/load' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $id = $self->param('id');

    my $branch;

    if( !defined $id || $id eq 'default') {
        $branch = 'default';
    } else {
        $branch = $id;
    }

    eval {
      git::new_branch($branch);
      git::make($branch);

      my $path = git::get_branch_path($branch) . 'out/jspell-ao/';
      JspellExec::install($path, $branch);
    };

    if ($@) {
      warn "NOT OK: $@";
      return $self->render(json => {status => 'NOT OK', message => $@}) if $self->stash('format') eq 'json';
    };

    return $self->render(json => {status => 'OK', message => "Repositório $branch criado e pronto para uso."}) if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };

  # GET /manager/reload.json?id=mybranch
  get  '/manager/reload' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $id = $self->param('id');

    my $branch;

    if( $id eq 'default' || !defined $id ) {
        return $self->render(json => '0') if $self->stash('format') eq 'json';
    } else {
        $branch = $id;
    }
    eval {
      git::make($branch);

      my $path = git::get_branch_path($branch) . 'out/jspell-ao/';
      JspellExec::install($path, $branch);
    };

    if ($@) {
      warn "NOT OK: $@";
      return $self->render(json => {status => 'NOT OK', message => $@}) if $self->stash('format') eq 'json';
    };

    return $self->render(json => {status => 'OK', message => "Repositório $branch recarregado e pronto para uso."}) if $self->stash('format') eq 'json';
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

    eval {
      git::commit($branch, $message);
    };

    if ($@) {
      warn "NOT OK: $@";
      return $self->render(json => {status => 'NOT OK', message => $@}) if $self->stash('format') eq 'json';
    };

    return $self->render(json => {status => 'OK', message => "Commit em $branch efetuado com sucesso."}) if $self->stash('format') eq 'json';
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

    eval {
      git::push_to_git($branch);
    };

    if ($@) {
      warn "NOT OK: $@";
      return $self->render(json => {status => 'NOT OK', message => $@}) if $self->stash('format') eq 'json';
    };

    return $self->render(json => {status => 'OK', message => "Mudanças em $branch enviadas para o Github."}) if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };

  # GET /manager/delete.json?id=mybranch
  get  '/manager/delete' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $id = $self->param('id');

    my $branch;

    if( $id eq 'default' || !defined $id ) {
        return $self->render(json => {status => 'NOT OK', message => "Impossível excluir repositório default."}) if $self->stash('format') eq 'json';
    }

    eval {
      git::DELETE($branch);
    };

    if ($@) {
      warn "NOT OK: $@";
      return $self->render(json => {status => 'NOT OK', message => $@}) if $self->stash('format') eq 'json';
    };

    return $self->render(json => '1') if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };

  # GET /manager/status.json?id=mybranch
  get  '/manager/status' => [format => [qw(json)]] => sub {
    my $self = shift;
    my $id = $self->param('id');

    my $branch;

    if( $id eq 'default' || !defined $id ) {
        return $self->render(json => '0') if $self->stash('format') eq 'json';
    } else {
        $branch = $id;
    }

    eval {
      git::status($branch);
    };

    if ($@) {
      warn "NOT OK: $@";
      return $self->render(json => {status => 'NOT OK', message => $@}) if $self->stash('format') eq 'json';
    };

    return $self->render(json => '1') if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };


  # GET /jspell/try.json?entry=abismal%2F%23an%2Fp%2F
  get  '/jspell/try' => [format => [qw(json)]] => sub {
    local$SIG{CHLD} = 'IGNORE';
    my $self = shift;
    my $entrada = $self->param('entry');

    # my $str = query_singleton("../out/jspell-ao/", $entrada);
    my $path = git::get_branch_path('default') . 'out/jspell-ao/';
    my %res = JspellExec::query_singleton($path, $entrada);

    return $self->render(json => \%res) if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };

  # GET /jspell/analyse.json?id=default&lexeme=casa
  get  '/jspell/analyse' => [format => [qw(json)]] => sub {
    local$SIG{CHLD} = 'IGNORE';
    my $self = shift;
    my $palavra = $self->param('lexeme');
    my $id = $self->param('id');
    
    my $branch;

    if( !defined $id || $id eq '') {
        $branch = 'default';
    } else {
        $branch = $id;
    }

    my $path = git::get_branch_path($branch) . 'out/jspell-ao/';
    # print "Executando analyse.json - \n";
    # print " Branch: $branch \n";
    # print " Path: $path \n";
    # print " Lexeme: $palavra \n";

    my %res = JspellExec::query_default($path, $branch, $palavra);

    # print " Json: " . Dumper(%res). "\n ";
    

    return $self->render(json => \%res) if $self->stash('format') eq 'json';
    $self->render(text => 'apenas suporta json');
  };

init();  
app->start;


