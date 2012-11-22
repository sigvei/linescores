require 'spec_helper'

describe End do
  it "should not calculate with negative scores" do
    e = End.new
    e.our_score = -1
    e.their_score = 0

    e.should_not be_valid
  end

  it "should have a score of 0 when xed" do
    e = End.new({our_score: "X", their_score: ""})
    e.should be_xed
    e.result.should be_zero
    e.our_score.should be_nil
    e.their_score.should be_nil

    e = End.new({our_score: 4, their_score: "X"})
    e.should be_xed
    e.result.should be_zero
    e.our_score.should be_nil
    e.their_score.should be_nil
  end
end
