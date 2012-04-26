#use 'mongo'


#//
#// This ETL transfers a saint from its relational representation
#// (locally) into the mongodb representation - also saves the saint
#// to mongodb.
#//
class SaintMongoAdapter


  cattr_accessor :connection_manager


  # ETLs all saints in database (essentially, a refresh)
  def self.etl_all
    saints = Saint.all
    etl_saints(saints)
  end

  # ETL a list of saints
  def self.etl_saints(saints = [])
    saints.each { |saint| etl_saint(saint) }
  end

  # ETL a single saint
  def self.etl_saint(saint)
    delete_saint_etl(saint)
    saint_hash = construct_attrib_hash(saint)
    save_saint_etl(saint, saint_hash)
  end

  # wipes a saint from the database
  def self.delete_saint(saint)

  end

  def self.save_saint_etl(saint, saint_hash)
    Rails.logger.debug("SaintMongoEtl :: saving ETL to mongo for: #{saint.symbol}")

  end

  def self.construct_attrib_hash(saint)
    # construct a hash of arrays
    # format: {attrib_category_code => [attrib_code(.)*]}
    attrib_map = Hash.new
    attribs = saint.attribs

    # if a new attrib_cat, then create an entry and insert (if attrib cat visible)
    # if existing, then append to array of values
    attribs = saint.attribs
    attribs.each do |attrib|
      category = attrib.attrib_category
      next if (!category.visible)
      attrib_map[category.code] = [] if (!attrib_map[category.code])
      attrib_map[category.code] << attrib.code
    end
    attrib_map
  end


end


