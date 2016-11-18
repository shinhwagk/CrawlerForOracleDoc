unit module Tools;
use HTTP::Client;

sub getHtmlByHtml(Str $url) {
  my $client = HTTP::Client.new;
  my $response = $client.get($url);
  if ($response.success) {
    # say "download $url success.";
    return $response.content;
  } else {
    die "download url: $url. error!";
  }
}

sub downloadFile(Str $url,Str $file) is export {
  try {
    my $name = $url.split('/').tail;
    # say "start download $name";
    my $html = getHtmlByHtml($url);
    spurt $file, $html;
    # say "end download $name";
    CATCH {
      default {
        say "error info: " ~ $_ ~ " xxxx";
        downloadFile($url, $file);
      }
    }
  }
}