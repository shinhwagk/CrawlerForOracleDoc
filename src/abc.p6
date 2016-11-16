use HTTP::Client;
use JSON::Tiny;

my $client = HTTP::Client.new;

sub getREFRN(){
  my $response = $client.get('http://docs.oracle.com/database/122/REFRN/toc.htm');
  my regex cont3 { \w+ }
  my regex reg {
    '<li><a href="' <cont3> '.htm#' [\w|\-]+ '"><span class="secnum">' \d+ '.' \d+ '</span>' [\w|\s]+ '</a></li>'
  }
  if ($response.success) {
    if $response.content ~~ m:g/ <reg> / {
      for $/.list -> $l {
        say $l<reg><cont3>;
      }
    }
  }
}

getREFRN();

sub squared() {
  my $response = $client.get('http://docs.oracle.com/database/122/REFRN/SERVICE_NAMES.htm');
  if ($response.success) {
    return $response.content;
  }
}

# function filterDataDictionaryView(item: [string, string]): boolean {
#   return item[0].startsWith("2") || item[0].startsWith("3") || item[0].startsWith("4") || item[0].startsWith("5") || item[0].startsWith("6")
# }

sub filterDataDictionaryView(@item) {
  @item[0].starts-with("2") || @item[0].starts-with("3");;
}

my @animals = '3camel','vicuña','llama';
say filterDataDictionaryView(@animals);

my $html = squared();

say "html geted";

my regex cont { .*? }

my regex col2 {
  '<td class="cellalignment3902" headers="' [\w|\s]+ '">' \s* '<p>' <cont> \s* '</p>' \s* '</td>'
}

my regex col1  {
  '<td class="cellalignment3901" id="' [\w|\s]+ '" headers="' [\w|\s]+ '">' \s* '<p><span class="bold">' <cont> '</span></p>' \s* '</td>'
}

my regex doc {
  '<!-- class="inftblhruleinformal" -->' \s* '<div class="section">' <cont> '<!-- class="section" --></div>'
}

my regex trr {
  '<tr>' \s* <col1> \s* <col2> \s* '</tr>'
}

my %capitals = ();

if $html ~~ m:g/ <trr> / {
  for $/.list -> $tr {
    %capitals.push: ( "$tr<trr><col1><cont>" , "$tr<trr><col2><cont>");
  }
}