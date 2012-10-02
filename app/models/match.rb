# encoding: UTF-8
class Match < ActiveRecord::Base
  attr_accessible :location, :opponent, :time, :tournament

  validates :opponent, :presence => true

  has_many :ends, :order => "position"

  def score(nend=nil)
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

  def our_score(nend=nil)
    if nend # get score for a certain end
      if ends[nend - 1]      # if that end exists at all
        e = ends[nend - 1]   # get the end
        if e.won?            # we won the end
          e.result.abs
        elsif e.blanked? && e.our_hammer? # we blanked it
          0
        else                 # we lost or thet blanked
          nil
        end
      else # end does not exist
        nil
      end
    else # get the score for the entire match
      score[0]
    end
  end
  
  def opponent_score(nend=nil)
    if nend # get score for a certain end
      if ends[nend - 1]      # if that end exists at all
        e = ends[nend - 1]   # get the end
        if e.lost?           # we lost the end
          e.result.abs
        elsif e.blanked? && (! e.our_hammer?) # they blanked it
          0
        else                 # we won or blanked
          nil
        end
      else # end does not exist
        nil
      end
    else # get the score for the entire match
      score[1]
    end
  end

  def first_hammer?
    # TODO: Implement
    true
  end

  def their_first_hammer?
    not first_hammer?
  end
end
