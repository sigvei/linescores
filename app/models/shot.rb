class Shot < ActiveRecord::Base
  attr_accessible :call, :end_id, :player, :rock, :success, :team, :turn

  belongs_to :end

  CALLS = %w(D F G R W Z T H C S P X) 
  CALL_NAMES = {
    "D" => "Draw/come around",
    "F" => "Front",
    "G" => "Guard",
    "R" => "Raise",
    "W" => "Wick/soft-peel",
    "Z" => "Freeze",
    "T" => "Take-out",
    "H" => "Hit and roll",
    "C" => "Clearing",
    "S" => "Double take-out",
    "P" => "Promotion take-out",
    "X" => "Not considered"
  }
  DRAWS = %w(D F G R W Z)
  TAKEOUTS = %w(T H C S P)
  TURNS = %w(I O)
  SUCCESSES = [0, 25, 50, 75, 100, 125, 150]
  TEAMS = %w(us them)
  
  validates :rock, :uniqueness => { :scope => [:end_id, :team] }
  validates :team, :uniqueness => { :scope => [:end_id, :rock] }
  validates :rock, :inclusion => { :in => 1..8, :allow_nil => false }
  validates :team, :inclusion => { :in => TEAMS, :allow_nil => false }
  validates :turn, :inclusion => { :in => TURNS, :allow_nil => false }
  validates :call, :inclusion => { :in => CALLS }
  validates :success, :inclusion => { :in => SUCCESSES, :allow_nil => true }
  
end
