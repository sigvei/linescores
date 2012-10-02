class End < ActiveRecord::Base
  attr_accessible :match_id, :position, :result

  belongs_to :match

  acts_as_list :scope => :match

  def won?
    result > 0
  end

  def blanked?
    result == 0
  end

  def lost?
    result < 0
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
end
