require "rubygems"
require 'mongoid'

class Person
  include Mongoid::Document
  include Mongoid::Versioning
  field :name
  field :age
end
