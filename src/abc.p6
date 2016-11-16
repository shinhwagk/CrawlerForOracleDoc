use HTTP::Client;
use JSON::Tiny;

my $client = HTTP::Client.new;

sub squared() {
  my $response = $client.get('http://docs.oracle.com/database/122/REFRN/SERVICE_NAMES.htm');
  if ($response.success) {
    return $response.content;
  }
}

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

say %capitals;

my $json_as_string = to-json %capitals;

my $fh = open "testfile.json", :w;
$fh.print($json_as_string);
$fh.close;
