##
#  Saint timeline, by century
#
module Timeline
  class Century < Base

    def type
      "century"
    end

    def name
      "Century"
    end

    def timeline_headline
      "Saints by Century"
    end

    def timeline_text
      "Timeline of all saints, by century"
    end

    def zoom_adjustment
      -2
    end

    def render
      saints = Saint.all_published
      saint_dates = saints.map do |saint|
        # Retrieve century attrib, get the first and parse out only the number
        century = saint.get_attrib(AttribCategory::CENTURY)
        ct_match = /(\d+)/.match(century)
        return nil if ct_match.nil?

        #  Get actual birth date or start of century
        ct_value = saint.get_metadata_value(MetadataKey::BORN) || ((ct_match[0].to_i - 1) * 100 + 1)

        {
          :startDate => "#{ct_value},,",
          :headline => saint.symbol,
          :text => saint_display_text(saint),
          :asset => {
            :media => get_pic(saint),
            :thumbnail => get_thumbnail(saint),
            :caption => saint.symbol
          }
        }
      end

      #  Remove nil values
      saint_dates = saint_dates.reject { |obj| obj.nil? }

      ## All data, assembled
      {
        :timeline => {
          :headline => timeline_headline,
          :type => "default",
          :text => timeline_text,
          :asset => {},
          :date => saint_dates,
          :era => eras
        }
      }
    end

    ## Define all of our eras (define centuries)
    def eras
      [
        {headline:  '1st Century', startDate:    '0', endDate:  '100'},
        {headline:  '2nd Century', startDate:  '101', endDate:  '200'},
        {headline:  '3rd Century', startDate:  '201', endDate:  '300'},
        {headline:  '4th Century', startDate:  '301', endDate:  '400'},
        {headline:  '5th Century', startDate:  '401', endDate:  '500'},
        {headline:  '6th Century', startDate:  '501', endDate:  '600'},
        {headline:  '7th Century', startDate:  '601', endDate:  '700'},
        {headline:  '8th Century', startDate:  '701', endDate:  '800'},
        {headline:  '9th Century', startDate:  '801', endDate:  '900'},
        {headline: '10th Century', startDate:  '901', endDate: '1000'},
        {headline: '11th Century', startDate: '1001', endDate: '1100'},
        {headline: '12th Century', startDate: '1101', endDate: '1200'},
        {headline: '13th Century', startDate: '1201', endDate: '1300'},
        {headline: '14th Century', startDate: '1301', endDate: '1400'},
        {headline: '15th Century', startDate: '1401', endDate: '1500'},
        {headline: '16th Century', startDate: '1501', endDate: '1600'},
        {headline: '17th Century', startDate: '1601', endDate: '1700'},
        {headline: '18th Century', startDate: '1701', endDate: '1800'},
        {headline: '19th Century', startDate: '1801', endDate: '1900'},
        {headline: '20th Century', startDate: '1901', endDate: '2000'},
        {headline: '21st Century', startDate: '2001', endDate: '2100'}
      ]
    end

  end
end
