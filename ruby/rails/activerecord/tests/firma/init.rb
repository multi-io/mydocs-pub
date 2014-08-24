require 'shared_setup'

class Stadt < ActiveRecord::Base
  def self.table_name() "stadt" end
end


class Adresse < ActiveRecord::Base
  def self.table_name() "adresse" end
  belongs_to :stadt, :class_name=>"Stadt", :foreign_key=>"stadt_id"
end

#class Kunde < ActiveRecord::Base
#  belongs_to :wohnsitz, :class_name=>"Adresse", :foreign_key=>"wohnsitz_id"
#end



addrs = Adresse.find_all
towns = Stadt.find_all
