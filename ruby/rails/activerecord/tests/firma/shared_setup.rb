require 'active_record'
require 'logger'; class Logger; def format_message(severity, timestamp, msg, progname) "#{msg}\n" end; end

ActiveRecord::Base.logger = Logger.new(STDOUT)
#ActiveRecord::Base.logger = nil
ActiveRecord::Base.establish_connection(
  :adapter  => "mysql", 
  :host     => "localhost", 
  :username => "olaf", 
  :password => "mysqlpw", 
  :database => "tests"
)


class ActiveRecord::Base
  def self.db_table(name)
    class_eval <<-"EOS"
      def self.table_name() "#{name}" end
    EOS
  end
end
