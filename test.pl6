my $p2 = start {
  my $i = 0;
  for 1 .. 10 {
    $i -= $_
  }
  $i
}

my $p1 = start {
  my $i = 0;
  for 1 .. 10 {
    $i -= $_
  }
  $i
}
# my $result = await $p2;

my $promise2 = $p1.then(
    -> $v { say $v.result; "Second Result" }
);
say "ff2";
say $promise2.result;


await 