require 'init_kunde_bestellung_produkt'

grundig = Firma.find_first("name='Grundig'")

fernseher = Produkt.find_first("name='Fernseher'")

fernseher.preis = 1999
fernseher.add_hersteller(grundig)

fernseher.save


alle_kunden = Kunde.find_all

best = Bestellung.create
best.kunde = alle_kunden[1]
best.produkt = fernseher
best.anzahl = 2
best.save
