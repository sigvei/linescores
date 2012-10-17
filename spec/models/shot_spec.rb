require 'spec_helper'

describe Shot do
  describe "validations" do
    before(:each) do
      @m = Match.new(:opponent => "Test")
      @e = @m.ends.build
      @e.save

      @valid_attributes = {
        :turn => "I",
        :call => "D",
        :success => nil,
        :rock => 1,
        :team => "us",
        :player => "Thomas Ulsrud",
        :end_id => @e.id
      }
      @s = Shot.new(@valid_attributes)
    end
  
    it "should validate" do
      @s.should be_valid
    end

    it "should validate legal calls" do
      valid_calls = Shot::CALLS
      valid_calls.each do |call|
        @s.call = call
        @s.should be_valid
      end
    end

    it "should invalidate illegal calls" do
      invalid_calls = %w(A B E Draw Take-out) + [:D, :Z, :T, nil]
      invalid_calls.each do |call|
        @s.call = call
        @s.should_not be_valid
      end
    end

    it "should allow turns I and O" do
      @s.turn = "O"
      @s.should be_valid
    end

    it "should not allow other turns" do
      invalid_turns = %w(A B C In Out in out) + [nil, :I, :O]
      invalid_turns.each do |trn|
        @s.turn = trn
        @s.should_not be_valid
      end
    end

    it "should allow legal success rates" do
      (Shot::SUCCESSES + [nil, "25", "25.0"]).each do |scs|
        @s.success = scs
        @s.should be_valid
      end
    end

    it "should not allow other success rates" do
      [-25, 15, 175, 88].each do |scs|
        @s.success = scs
        @s.should_not be_valid
      end
    end
  end
end
