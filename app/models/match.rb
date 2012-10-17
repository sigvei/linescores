# encoding: UTF-8
class Match < ActiveRecord::Base
  attr_accessible :location, :opponent, :time, :tournament, :ends_attributes, :our_first_hammer

  validates :opponent, :presence => true

  has_many :ends, :order => "position"

  accepts_nested_attributes_for :ends, 
    :reject_if => lambda {|attrb| attrb[:our_score].blank? and attrb[:their_score].blank?},
    :allow_destroy => true

  def score
    if ends.size == 0
      [nil, nil]
    else
      ends.inject([0,0]) do |score, e|
        [ score[0] + (e.score[0] || 0),
          score[1] + (e.score[1] || 0) ]
      end
    end
  end

  def our_score
    score[0]
  end

  def opponent_score
    score[1]
  end

  def scorecard
    return nil unless ends
    ( [ [our_first_hammer?, their_first_hammer?] ] + ends.map(&:score) + [ score ] ).transpose
  end

  def their_first_hammer?
    not our_first_hammer?
  end
end
