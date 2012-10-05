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
  
  describe "score calculation" do
    before(:each) do
      @m = Match.new
      @m.opponent = "Test"
    end

    @testmatches = [
      { :answer => [4,2], :ends => [ [1,0], [0,2], [3,0] ]},
      { :answer => [6,0], :ends => [ [0,0], [2,0], [0,0], [4,0] ]},
      { :answer => [1,3], :ends => [ [1,2], [3,2], [1,3], [1,1] ]},
      { :answer => [0,0], :ends => [ [nil,nil] ] },
      { :answer => [2,0], :ends => [ [nil,nil], [2, nil] ] }
    ]

    @testmatches.each do |testdata|
      it "should calculcate scores correctly" do
        testdata[:ends].each do |e|
          @m.ends << End.new(:our_score => e[0], :their_score => e[1])
        end
        @m.save

        @m.score.should == testdata[:answer]
      end
    end
  end
end
