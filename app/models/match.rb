# encoding: UTF-8
class Match < ActiveRecord::Base
  attr_accessible :location, :opponent, :time, :tournament

  validates :opponent, :presence => true

  has_many :ends, :order => "position"

  def score
    if ends.size == 0
      [nil, nil]
    else
      ends.inject([0,0]) do |score, e|
        if e.result > 0
          score[0] += e.result
        else
          score[1] += e.result.abs
        end
        score
      end
    end
  end

  def our_score
    score[0]
  end
  
  def opponent_score
    score[1]
  end
end
