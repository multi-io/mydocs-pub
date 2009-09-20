#'a' =~ /\".*?\"/

'a' =~ /\"(.*?\)"/

#/\"(.*?)\"/.class.instance_methods
#/\"(.*?)\"/.match('foo"bar"baz')
#/\"(.*?)\"/.match('foo"bar"baz').to_a
/\"(.*?)\"/.match('foo"bar"baz')[1]



# run with "irb segfault.rb", and it dumps core. Remove any line, even
# one of the comment or empty lines, and it doesn't dump core anymore.


# ruby --version
# ruby 1.8.2 (2005-04-11) [i386-linux]
# irb --version
# irb 0.9(02/07/03)
