class End < ActiveRecord::Base
  attr_accessible :match_id, :position, :result

  belongs_to :match

  acts_as_list :scope => :match
end
