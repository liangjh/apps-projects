require 'nokogiri'
require 'net/http'


##
#  This class contains functionality that retreives HTML content from wikipedia and parses out
#  unnecessary content.  We're assuming here that all pages have some common HTML DOM structure
#  and that it is possible to extract and excise until we get pure HTML content
#

class WikipediaBioScraper

  class << self

    ##
    # Retrieve HTML data from wikipedia
    def get(saint_id, wiki_url)

      # Wiki and saint data
      return nil if (wiki_url.nil? || saint_id.nil?)

      # Retrieve from cache, if exists
      content = CacheManager.read(CacheConfig::PARTITION_SAINT_WIKI_BIO, saint_id)
      # DNE in cache - retrieve from wikipedia
      if (content.nil?)
        content = get_refined(wiki_url)
        CacheManager.write(CacheConfig::PARTITION_SAINT_WIKI_BIO, saint_id, content)
      end
      content
    end

    ##
    #  Retrieves raw content and then refines it (removes extra tags that we don't need)
    def get_refined(wiki_url)

      # Retrieve raw content
      raw = get_raw(wiki_url)

      # WIKIPEDIA HTML PARSE - working document content
      html = Nokogiri::HTML(raw)
      html = html.css('#bodyContent')
      refine_content(html)
      cleanup_content(html)

      #  Return HTML string
      html.to_html
    end

    ##
    #  Performs HTTP request to retrieve raw HTML content
    def get_raw(wiki_url)
      content_raw = nil
      begin
        content_raw = Net::HTTP.get(URI(wiki_url))
      rescue Exception => ex
        Rails.logger.error "Failed to retrieve content from url: #{wiki_url}"
      end
      content_raw
    end

    ##
    # Given raw HTML content, parse out anything unnecessary and return only the
    # HTML that we're interested in displaying
    def refine_content(html)

      # Remove content (blocks that contain stuff we don't want)
      html.css('#siteSub').remove
      html.css('.editsection').remove
      html.css('#contentSub').remove
      html.css('#jump-to-nav').remove
      html.css('.pef-notification-container').remove
      html.css('.dablink').remove
      html.css('.metadata').remove
      html.css('.infobox').remove
      html.css('#toc').remove
      html.css('.thumb').remove
      html.css('#rellink').remove
      html.css('#relarticle').remove
      html.css('.reflist').remove
      html.css('.navbox').remove
      html.css('#persondata').remove
      html.css('.printfooter').remove
      html.css('#catlinks').remove
      html.css('.visualClear').remove
      html.css('img').remove
      html.css('.noprint').remove
      html.css('sup').remove
      html.css('table').remove
      html
    end

    def cleanup_content(html)
      # Tag cleanup (remove tag, not children of tags)
      html.css('a').each { |a| a.swap(a.children) }
      html.css('span').each { |s| s.swap(s.children) }
      html.css('blockquote').each { |b| b.swap(b.children) }
      html.xpath('//@class').remove
      html.xpath('//@style').remove
      html.xpath('//@id').remove
      html
    end

  end

end

