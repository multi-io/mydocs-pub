require 'docs1'

Mongoid.configure{|config| name = "rubytests"; host = "localhost"; port=27017; config.database = Mongo::Connection.new.db(name)  }

p = Person.new; p.name = "Matz"; p.age=43
p.save
