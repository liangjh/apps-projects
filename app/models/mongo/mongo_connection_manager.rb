require 'mongo'

#
# Connection manager is a proxy into a mongodb database
# Manages connections, performs queries and updates, etc
# This is a connection manager, which means the
#
#
#

class MongoConnectionManager

  # attrib: pool size
  cattr_accessor :pool_size


  # Init a connection to a mongodb, and a database
  def initialize(server, port, db_name)
    @conn = MongoConnection.new(server, port, :pool_size => pool_size, :timeout => 10)
    @db = @conn[db_name]
  end

  # Performs a query and returns an array of hashes
  # Reads everything into memory and returns (its up to calling program
  # to understand context of information and parse appropriately
  def query(collection_name, query_hash)
    coll = @db[collection_name]
    results = []
    coll.find(query_hash).each { |row| results << row }
    results
  end


end


