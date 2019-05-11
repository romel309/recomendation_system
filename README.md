# Project for my class of Intelligent Systems

## Some useful commands

`mysql-ctl start`
https://medium.com/@sam.mail2me/recommendation-systems-collaborative-filtering-just-with-numpy-and-pandas-a-z-fa9868a95da2
`rails server -b $IP -p $PORT`

## This will reset your database and reload your current schema with all:

`rake db:reset db:migrate`

## This will destroy your db and then create it and then migrate your current schema:

`rake db:drop db:create db:migrate`

https://recomend-movies-romel309.c9users.io/phpmyadmin

`rail g controller raitings`

`rails g model Rating  user:references movie:references rating:integer`

 https://test-recomendation-system-romel309.c9users.io/phpmyadmin

# Relationships
A relation model only makes sense for a N-to-N relationship as you described it. 
When you choose to use has_and_belongs_to_many, you don't need to create a join model, but you still have to create the join table via a migration. 
The naming convention is then gadgets_users, because 'g' is before 'u' in the alphabet.

If you chose has_many :through, you could store additional information within the join table via a GadgetUser join model. For example if you wanted to record that a gadget belonged to a user for a given time,then this time information logically belongs to the "connection" between gadget and user so you should keep it in the join table.