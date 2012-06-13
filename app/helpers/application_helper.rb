
#//
#// Helper Methods located within this helper module
#//

module ApplicationHelper


  #//
  #//  Given a string mm/dd, creates a pretty representation
  #//  ie  12/12  => December 12
  #//  ie  04/13  => April 13
  #//
  def self.mm_dd_prettify(datestr)
    return nil if (datestr.nil?)

    mdata = /(\d*)\/(\d*)/.match(datestr)
    month = mdata[1].to_i
    day = mdata[2].to_i

    month_pretty = case month
      when  1; "January"
      when  2; "February"
      when  3; "March"
      when  4; "April"
      when  5; "May"
      when  6; "June"
      when  7; "July"
      when  8; "August"
      when  9; "September"
      when 10; "October"
      when 11; "November"
      when 12; "December"
    end

    month_pretty += " #{day}"
    month_pretty

  end

end
