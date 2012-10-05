# encoding: UTF-8
class Match < ActiveRecord::Base
  attr_accessible :location, :opponent, :time, :tournament, :ends_attributes

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
        [ score[0] + (e.our_score || 0),
          score[1] + (e.their_score || 0) ]
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
    ( [ [first_hammer?, their_first_hammer?] ] + ends.map(&:score) + [ score ] ).transpose
  end

  def first_hammer?
    # TODO: Implement
    true
  end

  def their_first_hammer?
    not first_hammer?
  end
end
