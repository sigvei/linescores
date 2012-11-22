class End < ActiveRecord::Base
  attr_accessible :match_id, :position, :result, :our_score, :their_score,
    :shots_attributes, :xed
  belongs_to :match, :inverse_of => :ends
  has_many :shots, :dependent => :destroy

  accepts_nested_attributes_for :shots,
    :reject_if => lambda {|p| [p[:call], p[:turn], p[:success]].all?(&:blank?)},
    :allow_destroy => true
  validates :our_score, :their_score, :inclusion => (0..8), :allow_blank => true
  validate :xed_ends_must_be_zeroed
  acts_as_list :scope => :match

  before_save :normalize_scores

  def result
    (our_score || 0) - (their_score || 0)
  end

  # The score is an array [us,them] given *with pretty printing*, i.e.
  # nil for zero points except when blanking with hammer, and Xes
  def score
    normalize_scores
    [:our, :their].map{|team| send("#{team.to_s}_display_score") }
  end

  def our_display_score
    display_score(:our)
  end

  def their_display_score
    display_score(:their)
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
      match.our_first_hammer?
    else
      higher_item.lost? || (higher_item.blanked? && higher_item.our_hammer?)
    end
  end

  def their_hammer?
    ! our_hammer?
  end

  def stole?
    won? && (not our_hammer?)
  end

  def our_score=(score)
    check_x_and_set(:our_score, score)
  end

  def their_score=(score)
    check_x_and_set(:their_score, score)
  end

  private

  def check_x_and_set(field, value)
    if value.to_s.try(:upcase) == "X"
      write_attribute(:our_score, nil)
      write_attribute(:their_score, nil)
      self.xed=true
    else
      write_attribute(field, value)
    end
  end

  def normalize_scores
    if self.our_score.try(:nonzero?) && self.their_score.try(:nonzero?)
      if self.result > 0
        self.our_score = self.result
        self.their_score = nil
      else
        self.their_score = self.result.abs
        self.our_score = nil
      end
    elsif self.our_score != self.their_score
      self.our_score = nil if self.our_score == 0
      self.their_score = nil if self.their_score == 0
    end
  end

  def xed_ends_must_be_zeroed
    if xed? && result != 0
      errors.add(:base, "No points allowed in an Xed end (end #{position})")
    end
  end

  def display_score(team)
    if new_record?
      scr = send("#{team.to_s}_score")
    else
      if xed?
        "X"
      elsif result == 0
        send("#{team.to_s}_hammer?") ? 0 : nil
      else
        scr = send("#{team.to_s}_score").to_i
        scr > 0 ? scr : nil
      end
    end
  end
end
