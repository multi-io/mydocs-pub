require 'shared_setup'

module Enumerable
  def sum
    self.inject(0){|part,new| part+new}
  end
end

class Kunde < ActiveRecord::Base
  db_table "kunde"
  belongs_to :wohnsitz, :class_name=>"Adresse", :foreign_key=>"wohnsitz_id"
  has_many :bestellungen, :class_name=>"Bestellung", :foreign_key=>"kunde_id"

  def zu_zahlen
    self.bestellungen.map{|b|b.anzahl*b.produkt.preis}.sum
  end
end


class Adresse < ActiveRecord::Base
  db_table "adresse"
  #belongs_to :stadt, :class_name=>"Stadt", :foreign_key=>"stadt_id"
end


class Bestellung < ActiveRecord::Base
  db_table "bestellung"
  belongs_to :kunde, :class_name=>"Kunde", :foreign_key=>"kunde_id"
  belongs_to :produkt, :class_name=>"Produkt", :foreign_key=>"produkt_id"

  def gesamtpreis
    self.anzahl * self.produkt.preis
  end
end


class Produkt < ActiveRecord::Base
  db_table "produkt"

  has_and_belongs_to_many :hersteller, :class_name=>"Firma",
                                       :table_name=>"firma",   # QU: shouldn't this be determined using <class_name>.table_name ?
                                       :join_table=>"produkt_hersteller",
                                       :foreign_key=>"produkt_id"
end


class Firma < ActiveRecord::Base
  db_table "firma"
  has_and_belongs_to_many :produkt, :class_name=>"Produkt",
                                    :table_name=>"produkt",
                                    :join_table=>"produkt_hersteller",
                                    :foreign_key=>"firma_id"
end


