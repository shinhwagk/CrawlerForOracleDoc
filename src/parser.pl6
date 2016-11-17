use HTTP::Client;
use JSON::Tiny;

my $client = HTTP::Client.new;

my @DataDictionaryViews;
my @Parameters;
my @DynamicPerformanceViews;

sub getHtml(){
  my $response = $client.get('http://docs.oracle.com/database/122/REFRN/toc.htm');
  if ($response.success) {
    spurt "toc.htm", $$response.content;
  }
}

# getHtml();

sub getREFRN(){
  # my $response = $client.get('http://docs.oracle.com/database/122/REFRN/toc.htm');
  my regex pname { <:Lu>+ [<:Lu>|_|\d|\-|\w|\$]* }
  my regex urlname { <:Lu>+[<:Lu>|_|\d|\-|\w]* }
  my regex number1 { \d+ }
  my regex reg {
    '<li><a href="' <urlname> '.htm#' .*? '"><span class="secnum">' <number1> '.' \d+ '</span>'\s+ <pname> '</a></li>'
  }
  # if ($response.success) {
    # spurt "toc.htm", $$response.content;
    my $data = slurp "data/toc.htm";
    if $data ~~ m:g/ <reg> / {
      for $/.list -> $l {
        my $reg = $l<reg>;
        given $reg<number1> {
          when 1 {
            my @tmp = $reg<urlname>.chomp,$reg<pname>.chomp;
            @Parameters.push(@tmp);
          }
          when 2..6 { 
            my @tmp = $reg<urlname>.chomp,$reg<pname>.chomp;
            @DataDictionaryViews.push(@tmp) 
          }
          when 7..9 {
            my @tmp = $reg<urlname>.chomp,$reg<pname>.chomp;
            @DynamicPerformanceViews.push(@tmp) 
          }
          default  { say "huh?" }
        }
      }

      my $parameter-json = to-json @Parameters;
      spurt "data/Parameters.json", $parameter-json;
      my $data-dictionary-json = to-json @DataDictionaryViews;
      spurt "data/DataDictionaryViews.json", $data-dictionary-json;
      my $dynamic-performance-json = to-json @DynamicPerformanceViews;
      spurt "data/DynamicPerformanceViews.json", $dynamic-performance-json;
    }
}

# getREFRN();
my $data = slurp "data/Parameters.json";
@Parameters = from-json $data;

sub parserParameter($name) {

  sub squared($par-name) {
    my $response = $client.get("http://docs.oracle.com/database/122/REFRN/" ~ $par-name ~".htm");
    # say "http://docs.oracle.com/database/122/REFRN/" ~ $par-name ~".htm";
    if ($response.success) {
      return $response.content;
    }
  }

  my $html = squared $name;

  my regex cont { .*? }

  my regex col2 {
    '<td class="' \w+ '" headers="' [\w|\s]+ '">' \s* '<p>' <cont> \s* '</p>' \s* '</td>'
  }

  my regex col1  {
    '<td class="' \w+ '" id="' [\w|\s]+ '" headers="' [\w|\s]+ '">' \s* '<p><span class="bold">' <cont> '</span></p>' \s* '</td>'
  }

  my regex trr {
    '<tr>' \s* <col1> \s* <col2> \s* '</tr>'
  }

  my regex section {
   '<!-- class="inftblhruleinformal" -->' \s* <cont> \s* '<footer>'
  }

  my %capitals = ();

  if $html ~~ m:g/ <trr> / {
    for $/.list -> $tr {
      %capitals.push: ( "$tr<trr><col1><cont>" , "$tr<trr><col2><cont>");
    }
  } else {
    die "error: $name property parser faile.";
  }

  my $section = "";

  if $html ~~ / <section> / {
    # say "ok";
    $section = "$/<section><cont>";
    # $section = $<section><cont>;

  } else {
    die "error: $name section parser faile.";
  }

  my %obj = ("property", %capitals,"section", $section);

  my $jsonStr = to-json %obj;

  spurt 'data/Parameters/' ~ $name ~ '.json', $jsonStr;
  say $name ~ " parser and save success";
}

for @Parameters[0].list -> $r {
  parserParameter($r[0]);
}