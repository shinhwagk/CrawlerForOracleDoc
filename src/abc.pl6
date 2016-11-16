use HTTP::Client;
use JSON::Tiny;

my $client = HTTP::Client.new;

my @DataDictionaryViews;
my @Parameters;
my @DynamicPerformanceViews;

sub getREFRN(){
  # my $response = $client.get('http://docs.oracle.com/database/122/REFRN/toc.htm');
  my regex pname { <:Lu>+[<:Lu>|_|\d|\-|\w|\$]* }
  my regex number1 { \d+ }
  my regex reg {
    '<li><a href="' <:Lu>+[<:Lu>|_|\d|\-|\w]* '.htm#' .*? '"><span class="secnum">' <number1> '.' \d+ '</span>'\s+ <pname> '</a></li>'
  }
  # if ($response.success) {
    # spurt "toc.htm", $$response.content;
    my $data = slurp "toc.htm";
    if $data ~~ m:g/ <reg> / {
      for $/.list -> $l {
        my $reg = $l<reg>;
        given $reg<number1> {
          when 1 { @Parameters.push($reg<pname>) }
          when 2..6 { @DataDictionaryViews.push($reg<pname>) }
          when 7..9 { @DynamicPerformanceViews.push($reg<pname>) }
          default  { say "huh?" }
        }
      }
      say @Parameters.elems;
      say @DataDictionaryViews.elems;
      say @DynamicPerformanceViews.elems;
    }
  # }
}

getREFRN();

sub squared($par-name) {
  my $response = $client.get("http://docs.oracle.com/database/122/REFRN/" ~ $par-name ~".htm");
  say "http://docs.oracle.com/database/122/REFRN/" ~ $par-name ~".htm";
  # if ($response.success) {
    # return $response.content;
  # }
}
squared "aaa"

# # function filterDataDictionaryView(item: [string, string]): boolean {
# #   return item[0].startsWith("2") || item[0].startsWith("3") || item[0].startsWith("4") || item[0].startsWith("5") || item[0].startsWith("6")
# # }

# sub filterDataDictionaryView(@item) {
#   @item[0].starts-with("2") || @item[0].starts-with("3");;
# }

# my @animals = '3camel','vicuña','llama';
# say filterDataDictionaryView(@animals);

# my $html = squared();

# say "html geted";

# my regex cont { .*? }

# my regex col2 {
#   '<td class="cellalignment3902" headers="' [\w|\s]+ '">' \s* '<p>' <cont> \s* '</p>' \s* '</td>'
# }

# my regex col1  {
#   '<td class="cellalignment3901" id="' [\w|\s]+ '" headers="' [\w|\s]+ '">' \s* '<p><span class="bold">' <cont> '</span></p>' \s* '</td>'
# }

# my regex doc {
#   '<!-- class="inftblhruleinformal" -->' \s* '<div class="section">' <cont> '<!-- class="section" --></div>'
# }

# my regex trr {
#   '<tr>' \s* <col1> \s* <col2> \s* '</tr>'
# }

# my %capitals = ();

# if $html ~~ m:g/ <trr> / {
#   for $/.list -> $tr {
#     %capitals.push: ( "$tr<trr><col1><cont>" , "$tr<trr><col2><cont>");
#   }
# }