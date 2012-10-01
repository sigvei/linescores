require 'spec_helper'

describe Match do
  it "should not accept an opponent-less match" do
    @m = Match.new
    @m.location = "Loc 123"
    @m.time = Time.now
    @m.tournament = "Seriespillet 2012"
    @m.opponent = ""
    @m.should_not be_valid
  end
end
