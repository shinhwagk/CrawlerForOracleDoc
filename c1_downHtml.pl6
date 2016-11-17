use HTTP::Client;

my $client = HTTP::Client.new;

mkdir 'data';
mkdir 'data/html/Parameters';
mkdir 'data/html/DataDictionaryViews';
mkdir 'data/html/DynamicPerformanceViews';

say "start download toc.html;";
my $response = $client.get("http://docs.oracle.com/database/122/REFRN/toc.htm");
if ($response.success) {
  spurt "data/html/toc.htm", $$response.content;
  say "download toc.htm success.";
} else {
  die "download url: http://docs.oracle.com/database/122/REFRN/toc.htm. error!";
}

my $toc-htm = slurp "data/html/toc.htm";

my regex itemname { <:Lu>+ [<:Lu>|_|\d|\-|\w|\$]* }
my regex urlname { <:Lu>+[<:Lu>|_|\d|\-|\w]* }
my regex number { \d+ }
my regex reg {
  '<li><a href="' <urlname> '.htm#' .*? '"><span class="secnum">' <number> '.' \d+ '</span>'\s+ <itemname> '</a></li>'
}

if $toc-htm ~~ m:g/ <reg> / {
  # my $a = ~$/;
  # say $a.WHAT;
  for $/.list -> $l {
    my $reg = $l<reg>;
    my $type;
    given $reg<number> {
      when 1 { $type = "Parameters"; }
      when 2..6 { $type = "DataDictionaryViews"; }
      when 7..9 { $type = "DynamicPerformanceViews"; }
      default  { say "huh?" }
    }

    my $url = "http://docs.oracle.com/database/122/REFRN/" ~ ~$reg<urlname> ~ ".htm";

    say "start download $reg<itemname>; url: $url";
    # my $client = HTTP::Client.new;
    my $response = $client.get($url);
    if ($response.success) {
      my $html = $response.content;
      if $html ~~ / '<body>' $<content> = .*? '</body>' / {
        spurt "data/html/" ~ $type ~ "/" ~ $reg<itemname>.chomp ~ ".htm", ~$<content>;
      }
    } else {
      die "download url: http://docs.oracle.com/database/122/REFRN/" ~ $$reg<urlname>.chomp ~".htm." ~ " error!";
    }
    say "download html: $reg<itemname>.html success.";
  }
}