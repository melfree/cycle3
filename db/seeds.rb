# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

big   = User.create! email: "example@gmail.com", name: 'The Notorious B.I.G.', password: 'secretpass'
snoop = User.create! email: "example@aol.com", name: 'Snoop Dogg', password: 'secretpass'
flex  = User.create! email: "example@yahoo.com", name: 'Funkmaster Flex', password: 'secretpass'

Message.create! title: 'Tha Shiznit', content: 'Poppin, stoppin, hoppin like a rabbit', user: snoop
Message.create! title: 'Hypnotize ', content: 'Hah, sicker than your average Poppa', user: big
