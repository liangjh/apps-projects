
#//
#//  This table stores system settings in key-value pairs
#//  We can use this for tuning certain settings on the application dynamically
#//  The region is used to categorize settings, although in some cases it will just be a
#//  copy of the key
#//
#//  Columns: region, key, value
#//

class Setting < ActiveRecord::Base

  #// Some pre-constructed queries
  scope :by_region_and_key, lambda { |r,k| where(:region => r, :key => k) }
  scope :by_key, lambda { |k| where(:key => k) }


end




