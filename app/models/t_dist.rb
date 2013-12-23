
##
#  T Distribution (Student's Distribution)
class TDist < ActiveRecord::Base
  attr_accessible :alpha, :df, :p_cum, :tv_1t, :tv_2t
  attr_accessor :left_dist, :right_dist

  scope :lt_alpha,  lambda { |alpha, df| where("alpha < ? and df = ?", alpha, df).order(:alpha) }
  scope :lt_tv_one, lambda { |tval,  df| where("tv_1t < ? and df = ?", tval,  df).order(:tv_1t) }
  scope :lt_tv_two, lambda { |tval,  df| where("tv_2t < ? and df = ?", tval,  df).order(:tv_2t) }
  scope :gt_alpha,  lambda { |alpha, df| where("alpha > ? and df = ?", alpha, df).order(:alpha) }
  scope :gt_tv_one, lambda { |tval,  df| where("tv_1t > ? and df = ?", tval,  df).order(:tv_1t) }
  scope :gt_tv_two, lambda { |tval,  df| where("tv_2t > ? and df = ?", tval,  df).order(:tv_2t) }

  class << self


    def range_by_alpha(alpha, df)
      [lt_alpha(alpha, df).last, gt_alpha(alpha, df).first]
    end

    def range_by_tv_one_sided(tv, df)
      [lt_tv_one(tv, df).last, gt_tv_one(tv, df).first]
    end

    def range_by_tv_two_sided(tv, df)
      [lt_tv_two(tv, df).last, gt_tv_two(tv, df).first]
    end


  end

  def range=(elem = [])
    self.left_dist = elem[0]
    self.right_dist = elem[1]
  end

end
