#!/usr/bin/ruby -w

class C
  def cat_file(filename,openmode)
    File.open(filename,openmode) do |file|
      file.read
    end
  end

  def test
    filename="/etc/issue"
    begin
      cnt=cat_file filename, "r+"
    rescue
      cnt=cat_file filename, "r"
    end
    print "contents of #{filename}:\n#{cnt}\n"
  end

end


$LOGGING=false
begin
  load "~/.appconfig"
rescue LoadError
  #ignore
end

if $LOGGING
  require 'logging'

  class C
    include Logging
    add_logging
  end
end

C.new.test
