# From: "tag" at 67.168.40.46
#Summary: eval error appears to be lying to me...

# This is a dynamic method constructor thing... FORMAT and TOKENS are locally scoped
# scalars that have values of 0 and 1 and use compile time optimizations to remove
# chunks of code on the fly.

# See __END__ for the error.

use Carp;

local $FORMAT = 0;
local $TOKENS = 1;

eval qq(
        package $self->{package};
        sub $name {
                   my (\$self, \@args) = \@_;
                   my \@format;

                   if ($FORMAT) {
                       my \$contract = \$self->{-format}{$name};

                       \@format = splice \@args, 0, scalar \@\$contract;

                       unless (Phrasebook::Contract::PRODUCTION) {
                           for my \$i (0..\$#\$contract) {
                                       my \$error = \$contract->[\$i]->(\$format[\$i]);
                                       croak \$error if defined \$error;
                                   }
                       }
                   }

                   my \$statement;

                   if ($TOKENS) {
                       my \$parsed = q($query);
                       (\$parsed, \@args) = \$self->tokenize(q($name), q($query), \@args);
                       \$statement = \${ \$self->{-dbh} }->prepare(\$parsed, \@format);
                   }
                   else {
                       \$statement = \${ \$self->{-dbh} }->prepare(q($query), \@format);
                   }


                   unless (Phrasebook::Contract::PRODUCTION) {
                       \$statement->{private_require} = \$self->{-require}{$name};
                       \$statement->{private_expect}  = \$self->{-expect}{$name};
                   }

                   \$statement->execute(\@args);
                   return \$statement;
                  }) or croak "Error creating method: $@";

__END__
Error creating method: "my" variable $parsed masks earlier declaration in same scope at (eval 8) line 30, <PHRASEBOOK> chunk 1.

*Note: It doesn't matter what the hell I name the variable, 
       that single my() continually gives me this error on 
       the first iteration of this subroutine.

