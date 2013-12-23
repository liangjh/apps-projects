##
#  T Distribution (Student's Distribution)
class TDist < ActiveRecord::Base
  attr_accessible :alpha, :df, :p_cum, :tv_1t, :tv_2t
end
