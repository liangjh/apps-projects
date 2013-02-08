require 'tire'
require 'yajl/json_gem'

##
#  Saint Search
#  Primary gateway into ElasticSearch
#  This class contains both the search methods as well as the ETL into the search index
#
module Search::Saint

  # Index name
  SAINT_INDEX_NAME = :saints

  # Restrict returned results to specific fields
  RETURNED_FIELDS = [:id, :name, :symbol, :attribs]


  class << self

    ##
    # Perform search action
    # We can search by discrete attributes and by a plain search term on all attribs
    def search(question = nil, attribs = [])

      # Don't query if there is no data
      return [] if (question.nil? && attribs.empty?)

      # Build search query
      search_query = Tire.search SAINT_INDEX_NAME do

        # Bool search will allow for adaptive facets
        # and full-text string-based search
        query do
          boolean do
            if (question.present?)
              must { string "*#{question}*" }
            end
            attribs.each do |attrib|
              must { term :attribs, attrib }
            end
          end
        end

        # Restrict fields returned by search result
        fields RETURNED_FIELDS

        # Attributes (facets)
        # Return available facets
        facet 'current-tags' do
          terms :attribs
        end
      end
      query_results = search_query.results
      Search::SaintResult.new(query_results)
    end

    ##
    # Adds a list of saints to the elasticsearch search index
    def add_to_index(saints = [], clear_index = false)

      Rails.logger.info "Search::Saint: saving saints #{saints.map(&:id)} to elastic search index"

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
          :name => saint.get_metadata_value(MetadataKey::NAME),
          :attribs => saint.attribs.map(&:code),
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
