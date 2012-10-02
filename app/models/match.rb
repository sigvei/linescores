# encoding: UTF-8
class Match < ActiveRecord::Base
  attr_accessible :location, :opponent, :time, :tournament

  validates :opponent, :presence => true

  def our_score
    # TODO: implement
    rand(15)
  end
  
  def opponent_score
    # TODO: implement
    rand(15)
  end
end
