require 'tire'
require 'yajl/json_gem'

##
#  Saint Search
#  Primary gateway into ElasticSearch
#  This class contains both the search methods as well as the ETL into the search index
#
module Search::Saint

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
      query_start = Time.now
      search_query = Tire.search :saints do

        # Bool search will allow for adaptive facets
        # and full-text string-based search
        query do
          boolean do
            if (question.present?)
              must do
                # The rewrite option will apparently reorder the search results
                # with the relevant boost values - render top 1000 (will render any n, but top 1000 will ensure
                # that we catch as many results as we can)
                string "*#{question}*", :rewrite => :top_terms_1000
              end
            end
            attribs.each do |attrib|
              must do
                term :attribs, attrib
              end
            end
          end
        end

        # Return as many matching results as we can - default is only 10
        size 1000

        # Restrict fields returned by search result
        fields RETURNED_FIELDS

        # Attributes (facets)
        # Return available facets
        facet 'current-tags' do
          terms :attribs, :size => 1000
        end
      end

      #  Run query, get results
      query_results = search_query.results

      #  Log elapsed time of the query
      query_end = Time.now
      elapsed_millis = (query_end - query_start) * 1000.0
      Rails.logger.info "search-performance|query:#{question}|filter-count:#{attribs.length}|time:#{elapsed_millis}"

      #  Construct result wrapper
      Search::SaintResult.new(query_results)

    end

    ##
    # Adds a list of saints to the elasticsearch search index
    def add_to_index(saints = [], clear_index = false)

      Rails.logger.info "Search::Saint: saving saints #{saints.map(&:id)} to elastic search index"

      # ETL the list into an array of hash-based objects
      list_etl = etl(saints)

      # Index all records (clear out if its a full refresh)
      Tire.index :saints do
        # Delete the existing index only if its a full refresh
        if (clear_index)
          delete
          create
          mapping :saint, :properties => {
                :id       => {:type => 'integer', :index => 'not_analyzed'},
                :symbol   => {:type => 'string',  :boost => 2.0, :index => 'analyzed'},
                :name     => {:type => 'string',  :boost => 2.0, :index => 'analyzed'},
                :attribs  => {:type => 'string',  :index => 'analyzed'},
                :metadata => {:type => 'string',  :index => 'analyzed'}
              }

        end

        # Full import of generated list
        import list_etl
        # list_etl.each do |doc|
          # store doc
        # end
        refresh
      end

    end

    ##
    # Refresh the entire index
    def refresh_index_full
      saints = Saint.all_published
      add_to_index(saints, true)
    end

    ##
    # Clears out the search index
    def clear_index
      Tire.index :saints do
        delete
        create
        refresh
      end
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
          :type => :saint,
          :id => saint.id,
          :symbol => saint.symbol,
          :name => saint.get_metadata_value(MetadataKey::NAME),
          :attribs => saint.attribs.map(&:code),
          :metadata => mv.join(' ')
        }

        # Add constructed object to list
        saint_list << search_hash
      end
      saint_list
    end



  end


end
