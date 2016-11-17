use HTTP::Client;

my $client = HTTP::Client.new;

my $response = $client.get('http://docs.oracle.com/database/122/REFRN/toc.htm');
if ($response.success) {
  spurt "data/html/toc.htm", $$response.content;
} else {
  die "download url: http://docs.oracle.com/database/122/REFRN/toc.htm. error!";
}

my $toc-htm = slurp "data/html/toc.htm";

my regex name { <:Lu>+ [<:Lu>|_|\d|\-|\w|\$]* }
my regex urlname { <:Lu>+[<:Lu>|_|\d|\-|\w]* }
my regex number { \d+ }
my regex reg {
  '<li><a href="' <urlname> '.htm#' .*? '"><span class="secnum">' <number> '.' \d+ '</span>'\s+ <name> '</a></li>'
}

if $toc-htm ~~ m:g/ <reg> / {
  for $/.list -> $l {
    my $reg = $l<reg>;
    my $type;
    given $reg<number> {
      when 1 { $type = "Parameters"; }
      when 2..6 { $type = "DataDictionaryViews"; }
      when 7..9 { $type = "DynamicPerformanceViews"; }
      default  { say "huh?" }
    }
    my $response = $client.get("http://docs.oracle.com/database/122/REFRN/" ~ $$reg<urlname>.chomp ~".htm");
    if ($response.success) {
      my $html = $response.content;
      if $html ~~ / '<body>' $<content> = .*? '</body>' / {
        spurt "data/html/" ~ $type ~ "/" ~ $reg<name>.chomp ~ ".htm", ~$<content>;
      }
    } else {
      die "download url: http://docs.oracle.com/database/122/REFRN/" ~ $$reg<urlname>.chomp ~".htm." ~ " error!";
    }
    say "download html: $reg<name>.chomp success.";
  }
}