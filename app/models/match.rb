# encoding: UTF-8
class Match < ActiveRecord::Base
  attr_accessible :location, :opponent, :time, :tournament, 
    :ends_attributes, :our_first_hammer, :bambuser_id,
    :our_lead, :our_second, :our_third, :our_fourth, :our_alternate,
    :our_skip, :our_viceskip,
    :their_lead, :their_second, :their_third, :their_fourth, :their_alternate,
    :their_skip, :their_viceskip

  validates :opponent, :presence => true
  validates :our_skip, :our_viceskip, :their_skip, :their_viceskip, 
    :inclusion => { :in => (1..5), :allow_nil => true }

  validate :skip_and_viceskip_must_be_different

  has_many :ends, :order => "position"
  has_many :shots, :through => :ends

  accepts_nested_attributes_for :ends, 
    :reject_if => lambda {|attrb| attrb[:our_score].blank? && attrb[:their_score].blank?},
    :allow_destroy => true

  before_save do
    %w(our_skip their_skip our_viceskip their_viceskip).each do |fld|
      if send(fld).blank?
        send(fld + "=", nil)
      end
    end
  end

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

  # +rock+: what rock (1-8)
  # +team+: either :our or :their
  def default_player(rock, team)
    no_fourth = send(team.to_s + "_fourth").blank?
    third =  send(team.to_s + "_third").present?
    three_players = third && no_fourth
    if rock.in?(1..2) or (rock == 3 && three_players)
      1
    elsif rock.in?(3..4) or (rock.in?(4..6) && three_players)
      2
    elsif rock.in?(5..6) or (rock.in?(7..8) && three_players)
      3
    else
      4
    end
  end

  # +team+: either :our or :their
  # +num+: 1..5
  def player_name(team, num)
    send(team.to_s + "_" + %w(lead second third fourth alternate).at(num - 1))
  end

  def scorecard
    return nil unless ends.any?
    ( [ [our_first_hammer?, their_first_hammer?] ] + ends.map(&:score) + [ score ] ).transpose
  end

  def their_first_hammer?
    not our_first_hammer?
  end


  def our_lineup
    [ our_lead, our_second, our_third, our_fourth, our_alternate ]
  end

  def their_lineup
    [ their_lead, their_second, their_third, their_fourth, their_alternate ]
  end

  def to_summary
    "#{opponent}" + (ends.size > 0 ? " #{our_score} - #{opponent_score}" : "")
  end

  def to_description
    desc = <<-EOS
#{location}
#{tournament}
#{our_lineup.delete_if(&:blank?).to_sentence}
    EOS

    sc = scorecard
    if sc
      sc[0] << "Us"
      sc[1] << self.opponent
      desc += sc.map do |line|
        line.map do |cell|
          if cell === true
            "⚒"
          elsif cell === false
            " "
          elsif cell.nil?
            "  "
          elsif cell.is_a? String
            "%-10.10s" % cell
          else
            "%2d" % cell
          end
        end
      end.map{|line| line.join("\t")}.join("\n")
    end
    desc
  end

  def uid
    UUIDTools::UUID.sha1_create(UUIDTools::UUID_OID_NAMESPACE, id.to_s).to_s
  end

  private

  def skip_and_viceskip_must_be_different
    if (our_skip && our_viceskip) && our_skip == our_viceskip
      errors.add(:our_viceskip, "can't be the same as skip")
    end
    if (their_skip && their_viceskip) && their_skip == their_viceskip
      errors.add(:their_viceskip, "can't be the same as skip")
    end
  end
end
