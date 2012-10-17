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

  describe "default player per rock logic" do
    describe "with four versus three players" do
      before(:each) do
        @players = {
          :our_lead => "Haavard Vad Pettersson",
          :our_second => "Christoffer Svae",
          :our_third => "Torger Nergaard",
          :our_fourth => "Thomas Ulsrud",
          :their_lead => "Ben Hebert",
          :their_second => "John Morris",
          :their_third => "Kevin Martin" }

        @m = Match.new({ :opponent => "Team Martin" }.merge(@players))
      end

      it "should pick the right players" do
        corrects = [1,1,2,2,3,3,4,4]
        corrects.each_with_index do |c,i|
          @m.default_player(i + 1, :our).should == c
        end

        corrects = [1,1,1,2,2,2,3,3]
        corrects.each_with_index do |c,i|
          @m.default_player(i + 1, :their).should == c
        end
      end
    end

    describe "with three versus four players" do
      before(:each) do
        @players = {
          :our_lead => "Haavard Vad Pettersson",
          :our_second => "Christoffer Svae",
          :our_third => "Torger Nergaard",
          :their_lead => "Ben Hebert",
          :their_second => "John Morris",
          :their_third => "Marc Kennedy",
          :their_fourth => "Kevin Martin" }

        @m = Match.new({ :opponent => "Team Martin" }.merge(@players))
      end

      it "should pick the right players" do
        corrects = [1,1,1,2,2,2,3,3]
        corrects.each_with_index do |c,i|
          @m.default_player(i + 1, :our).should == c
        end

        corrects = [1,1,2,2,3,3,4,4]
        corrects.each_with_index do |c,i|
          @m.default_player(i + 1, :their).should == c
        end
      end
    end

    describe "with no players" do
      before(:each) do
        @m = Match.new( :opponent => "Team Martin" )
      end

      it "should default to standard rotation" do
        corrects = [1,1,2,2,3,3,4,4]
        corrects.each_with_index do |c,i|
          puts "Rock #{i + 1}, should be #{c}"
          @m.default_player(i + 1, :our).should == c
          @m.default_player(i + 1, :their).should == c
        end
      end
    end

  end
end
