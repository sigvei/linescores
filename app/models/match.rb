class Match < ActiveRecord::Base
  attr_accessible :location, :opponent, :time, :tournament

  validates :opponent, :presence => true
end
