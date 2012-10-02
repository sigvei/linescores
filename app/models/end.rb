class End < ActiveRecord::Base
  attr_accessible :match_id, :position, :result, :our_score, :their_score
  belongs_to :match
  validates :our_score, :their_score, :inclusion => (0..8), :allow_blank => true
  acts_as_list :scope => :match

  before_save :normalize_scores

  def result
    (our_score || 0) - (their_score || 0)
  end

  def won?
    result && result > 0
  end

  def blanked?
    result == 0
  end

  def lost?
    result && result < 0
  end

  def our_hammer?
    if first?
      match.first_hammer?
    else
      higher_item.lost? or (higher_item.blanked? and higher_item.our_hammer?)
    end
  end

  def stole?
    won? and (not our_hammer?)
  end

  private

  def normalize_scores
    if self.our_score.try(:nonzero?) and self.their_score.try(:nonzero?)
      if self.result > 0
        self.our_score = self.result
        self.their_score = nil
      else
        self.their_score = result.abs
        self.our_score = nil
      end
    end
  end
end
