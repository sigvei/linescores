require 'spec_helper'

describe End do
  it "should not calculate with negative scores" do
    e = End.new
    e.our_score = -1
    e.their_score = 0

    e.should_not be_valid
  end
end
