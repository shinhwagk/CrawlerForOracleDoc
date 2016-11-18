use JSON::Tiny;

my regex cont { .*? }

my regex col2 {
  '<td class="' \w+ '" headers="' [\w|\s]+ '">' \s* '<p>' <cont> \s* '</p>' \s* '</td>'
}

my regex col1  {
  '<td class="' \w+ '" id="' [\w|\s]+ '" headers="' [\w|\s]+ '">' \s* '<p><span class="bold">' <cont> '</span></p>' \s* '</td>'
}

my regex tr {
  '<tr>' \s* <col1> \s* <col2> \s* '</tr>'
}

my regex section {
  '<!-- class="inftblhruleinformal" -->' \s* '<div class="section">'? \s* <cont> \s* '<footer>'
}

sub getNote($html) {
  my @notes;
  my regex note {
    '<div class="infobox-note" id="' [\w|\-]+ '">' \s* '<p class="notep1">Note:</p>' \s* <cont> \s* '</div>' 
  }

  if $html ~~ m:g/ <note> / {
    for $/.list -> $note {
      @notes.push(~$note<note><cont>);
    }
  }

  return @notes;
}

sub getSeeAlso($html) {
  my @seealso;
  my regex note {
    '<div class="infoboxnotealso" id="' [\w|\-]+ '">' \s* '<p class="notep1">See Also:</p>' \s* <cont> \s* '</div>' 
  }

  if $html ~~ m:g/ <note> / {
    for $/.list -> $note {
      @seealso.push(~$note<note><cont>);
    }
  }

  return @seealso;
}


sub parser($xx) {
  my $before = now;
  my $path = $xx.path;
  my $name = $xx.basename.split('.')[0];

  my $html = slurp $path;

  my %capitals = ();

  if $html ~~ m:g/ <tr> / {
    for $/.list -> $tr {
      %capitals.push: ( ~$tr<tr><col1><cont> , ~$tr<tr><col2><cont>);
    }
  } else {
    die "error: property parser faile.";
  }

  my $section = "";

  if $html ~~ / <section> / {
    # say "ok";
    $section = "$/<section><cont>";
    # $section = $<section><cont>;
  } else {
    die "error: $name section parser faile.";
  }

  my @notes = getNote($section);
  my @seealso = getSeeAlso($section);
  
  my %obj = ();

  if @seealso.elems >= 1 && @notes.elems >= 1 {
    %obj = ("property", %capitals, "section", $section, "notes", @notes,"seealso",@seealso);
  } elsif  @seealso.elems >= 1 {
    %obj = ("property", %capitals, "section", $section, "seealso",@seealso);
  } elsif  @notes.elems >= 1 {
    %obj = ("property", %capitals, "section", $section, "notes", @notes);
  } else {
    %obj = ("property", %capitals, "section", $section);
  }

  
  my $parameter-json = to-json %obj;
  spurt 'data/parser/Parameters/' ~ $name ~ '.json', $parameter-json;
  my $after = now;
  my $zzz = $after-$before;
  # say "parser $name success : $zzz;";
}

# for dir "data/html/Parameters" -> $par {
#   start parser($par)
# }

(dir "data/html/Parameters").race.map({ parser($_) });

say "success.";
# my $html = slurp 'data/html/Parameters/TRANSACTIONS.htm';
# say $html;
# parser(IO::Path.new('data/html/Parameters/TRANSACTIONS.htm'));
# say "fff"