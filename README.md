# tspire-api
Repository for app: tspire-api
Flask-centric API implementation for TSpire


TODO:  
- serialize/deserialize markov matrices + save/cache values
- generate trump-spire + configurations for the above
- unsplash api integration on POS (hierarchical)
- unsplash api on general images (not based on search)
- image / text superposition algorithm (+small, +large)
- image save: generate guid + size moniker
- persistence (postgres) - save all created
- persistence (postgres) - retrieve last “x” created values


//
Postgres Notes

Starting Postgres
  brew services start postgres

Create database
  createdb tspire
  psql tspire

Table definition
/*
  tspires
    guid: varchar (primary key)
    img_file_lg: varchar
    img_file_sm: varchar
    title: varchar
    text: varchar
    created: datetime
*/

Grant privileges
  create user tspire with encrypted password ‘magamagamaga’;
  grant all privileges on database tspire to tspire;

Useful psql commands
  \l  : list databases
  \dt : list tables in database
  \d  : describe table
  \dv : list views
  \du : list users and roles
  \i  : execute sql commands from file
  \timing : turn on execution timing
  \q  : quite psql


