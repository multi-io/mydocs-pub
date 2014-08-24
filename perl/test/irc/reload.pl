# <finite> i mean i've got an object of class Blah::Storable. There is a
#           reference to it in an array, in another object. There is an object
#           method in Blah::Storable that needs to replace $self with an object
#           read from disk. After doing that, the object (when accessed from the
#           place that called the object method to load from disk, which is
#           outside the module entirely) is what I want, replaced.
# <finite> but in the array of object refs, I still see the old object.

package Blah::Storable;

sub new {
    bless { foo=>bar, baz=>42}, shift;
}


sub replace {
    my $self = shift;
    my $loadedObject = { foo=>hello, baz=>83};
    %{$self}=%{$loadedObject};
}




package main;

my $obj = Blah::Storable->new;

my @arr=(foo,$obj,bar);
print $arr[1]->{baz}, "\n";  # prints 42

$obj->replace;

print $arr[1]->{baz}, "\n";  # prints 83
