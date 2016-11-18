use HTTP::Client;
use lib 'lib';
use Tools;
use Init;

my $client = HTTP::Client.new;

# downloadFile("http://docs.oracle.com/database/122/REFRN/toc.htm","data/html/toc.htm");

my $toc-htm = slurp "data/html/toc.htm";

my regex itemname { <:Lu>+ [<:Lu>|_|\d|\-|\w|\$]* }
my regex urlname { <:Lu>+[<:Lu>|_|\d|\-|\w]* }
my regex number { \d+ }
my regex reg {
  '<li><a href="' <urlname> '.htm#' .*? '"><span class="secnum">' <number> '.' \d+ '</span>'\s+ <itemname> '</a></li>'
}

my @urls;

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

    my @info = $url,~$reg<itemname>,$type;

    @urls.push(@info);

  #   say "start download $reg<itemname>; url: $url";
  #   # my $client = HTTP::Client.new;
  #   my $response = $client.get($url);
  #   if ($response.success) {
  #     my $html = $response.content;
  #     if $html ~~ / '<body>' $<content> = .*? '</body>' / {
  #       spurt "data/html/" ~ $type ~ "/" ~ $reg<itemname>.chomp ~ ".htm", ~$<content>;
  #     }
  #   } else {
  #     die "download url: http://docs.oracle.com/database/122/REFRN/" ~ ~$reg<urlname> ~".htm." ~ " error!";
  #   }
  #   say "download html: $reg<itemname>.html success.";
  }
}

my $Parameters_cnt = 0;
my $DataDictionaryViews_cnt = 0;
my $DynamicPerformanceViews_cnt = 0;

sub squared(@url-info) {
    my Str $u = @url-info[0];
    my Str $n = @url-info[1];
    my Str $t = @url-info[2];

    downloadFile($u,"data/html/" ~ $t ~ "/" ~ $n ~ ".htm");

    given $t {
      when 'Parameters' { $Parameters_cnt += 1; }
      when 'DataDictionaryViews' { $DataDictionaryViews_cnt += 1; }
      when 'DynamicPerformanceViews' { $DynamicPerformanceViews_cnt += 1; }
    }
}

for @urls -> @url {
  squared(@url);
  say "$Parameters_cnt / $DataDictionaryViews_cnt / $DynamicPerformanceViews_cnt";
}

say "success.";