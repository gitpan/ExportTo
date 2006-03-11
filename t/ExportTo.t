use Test::More 'no_plan';

BEGIN { use_ok('ExportTo') };

{
  package HOGE;

  sub function1{
    return 1;
  }

  sub function2{
    return 2;
  }

  sub function3{
    return 3;
  }

  use ExportTo (HOGE2 => [qw/function1 function2/], HOGE3 => [qw/function3/]);
  use ExportTo (HOGE => [qw/Test::More::is/]);
  is(HOGE2::function1(), 1);
  is(HOGE2::function2(), 2);
  is(HOGE3::function3(), 3);
}

{
  package HOGEHOGE;
  use ExportTo;
  sub function1{
    return -1;
  }

  sub function2{
    return -2;
  }

  sub function3{
    return -3;
  }

  export_to('+HOGE' => [qw/function1 function2/], HOGE3 => [qw/+function3/]);
  export_to(HOGEHOGE => [qw/Test::More::is/]);

  is(HOGE::function1(), -1);
  is(HOGE::function2(), -2);
  is(HOGE3::function3(), -3);
}

