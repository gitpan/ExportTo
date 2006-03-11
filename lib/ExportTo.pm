package ExportTo;

use Carp();

our $VERSION = '0.01';

sub import{
  my %hash = $_[0] eq __PACKAGE__ ? @_[1 .. $#_] : @_;
  my $pkg = (caller)[0];
  *{$pkg . '::export_to'} = \&export_to;
  while(my($class, $subs) = each %hash){
    foreach my $sub (@$subs){
      my $esub;
      unless($sub =~ /::/){
        $esub = $class . '::' . $sub;
      }else{
        $sub =~ s{^(.+)::}{};
        $esub = $class . '::' . $sub;
        $pkg = $1;
      }
      $sub =~ s/\+//g;
      $esub =~ s/\+//g ? undef &{$esub} : $class->can($sub) && next;
      if(my $cr = $pkg->can($sub)){
        *{$esub} = $cr
      }else{
        Carp::croak($pkg, ' cannot do ' , $sub);
      }
    }
  }
}

*{ExportTo::export_to} = \&import;

1;

__END__
=pod

=head1 NAME

ExportTo - export function/method to namespace

=head1 SYNOPSIS

 package From;
 
 sub function1{
   # ...
 }
 
 sub function2{
   # ...
 }
 
 sub function3{
   # ...
 }
 
 use ExportTo (NameSpace1 => [qw/function1 function2/], NameSpace2 => [qw/function3/]);

 # Now, function1 and function2 are exported to 'NameSpace1' namespace.
 # function3 is exported to 'NameSpace2' namespace.
 
 # If 'NameSpace1'/'NameSpace2' namespace has same name function/method,
 # such a function/method is not exported and ExportTo croaks.
 # but if you want to override, you can do it as following.
 
 use ExportTo (NameSpace1 => qw/+function1 function2/);
 
 # if adding + to function/method name,
 # This override function/method which namespace already has with exported funtion/method.
 
 use ExportTo ('+NameSpace' => qw/function1 function2/);
 
 # if you add + to namespace name, all functions are exported even if namespace already has function/method.

=head1 DESCRIPTION

This module allow you to export/override subroutine/method to one namespace.
It can be used for mix-in, for extension of modules not using inheritance.

=head1 FUNCTION/METHOD

=over 4

=item export_to

 export_to(PACKAGE_NAME => [qw/FUNCTION_NAME/]);
 ExportTo->export_to(PACKAGE_NAME => [qw/FUNCTION_NAME/]);

These are as same as following.

 use ExportTo(PACKAGE_NAME => [qw/FUNCTION_NAME/]);

But, 'use' is needed to declare after declaration of function/method.
using 'export_to', you can write anywhere.

=back

=head1 AUTHOR

Ktat, E<lt>atusi@pure.ne.jpE<gt>

=head1 COPYRIGHT

Copyright 2006 by Ktat

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut
