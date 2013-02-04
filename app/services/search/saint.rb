require 'tire'
require 'yajl/json_gem'

##
#  Saint Search
#  This is the primary gateway into elastic search on a saint-by-saint basis
#
module Search::Saint

  # Index name
  SAINT_INDEX_NAME = :saints

  # Restrict returned results to specific fields
  RETURNED_FIELDS = [:id, :name, :symbol, :attribs]


  class << self

    ##
    # Perform search action
    # We can search by facets, or by a plain search term on all attribs
    def search(question = nil, attribs = [])

      return [] if (question.nil? || attribs.empty?)

      s = Tire.search SAINT_INDEX_NAME do
        # Search term
        query { string question } if (question.present?)
        # Don't need to return every field
        fields RETURNED_FIELDS
        # Attributes (facets)
        filter :terms, :attribs => attribs if (attribs.present?)
        # Always return applicable facets across search results
        facet 'current-tags' do
          terms :attribs
        end
      end
      s.results

    end

    ##
    # Adds a list of saints to the elasticsearch search index
    def add_to_index(saints = [], clear_index = false)

      # ETL the list into an array of hash-based objects
      list_etl = etl(saints)

      # Index all records (clear out if its a full refresh)
      Tire.index SAINT_INDEX_NAME do
        # Delete the existing index only if its a full refresh
        if (clear_index)
          delete
          create
        end

        # Full import of generated list
        import list_etl
        refresh
      end
    end

    ##
    # Refresh the entire index
    def refresh_index_full
      saints = Saint.all
      add_to_index(saints, true)
    end

    ##
    #  Return saint list, in hash format - this will be the actual content
    #  that is loaded into the search index
    def etl(saints = [])
      saint_list = []
      saints.each do |saint|

        # Construct all metadata (values and txt values)
        mv =  saint.metadata_values.select { |x| x.value.present? }.map(&:value)
        mv << saint.metadata_values.select { |x| x.value_text.present? }.map(&:value_text)

        # Construct search data object
        # metadata and postings are currently in general fields, but they can be broken out
        # TODO: investigate whether storage of names vs codes makes more sense
        # TODO: storage, boost factors, and index optimization
        search_hash = {
          :id => saint.id,
          :symbol => saint.symbol,
          :name => saint.get_metadata_values(MetadataKey::NAME),
          :attribs => saint.attribs.map(&:name),
          :metadata => mv.join(' '),
          :postings => saint.postings.map(&:content).join(' ')
        }

        # Add constructed object to list
        saint_list << search_hash
      end
      saint_list
    end



  end


end
