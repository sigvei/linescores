require 'spec_helper'

describe "matches/show" do
  before(:each) do
    @match = assign(:match, stub_model(Match,
      :opponent => "Opponent",
      :location => "Location",
      :tournament => "Tournament"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Opponent/)
    rendered.should match(/Location/)
    rendered.should match(/Tournament/)
  end

  it "does not render a stats board" do
    render
    rendered.should_not have_selector("table.stats")
  end

  describe "with results and video" do
    before(:each) do
      @match = assign(:match, FactoryGirl.create(:match_with_ends))
      @match.bambuser_id = "3084582"
      @match.save
    end

    it "renders iframe with video" do
      render
      rendered.should have_selector("iframe.matchvideo")
    end

    it "does render a scorecard" do
      render
      rendered.should have_selector("table.scorecard")
    end

    it "renders Xed ends correctly" do
      e = @match.ends.last
      e.our_score = "X"
      e.should be_xed
      e.save
      @match.reload
      render

      rendered.should have_selector("td", :text => "X", :count => 2)
    end
  end

  describe "without results or video" do
    before(:each) do
      @match = assign(:match, FactoryGirl.create(:match))
    end

    it "does not render a video iframe" do
      render
      rendered.should_not have_selector("iframe.matchvideo")
    end

    it "does not render a scorecard" do
      render
      rendered.should_not have_selector("table.scorecard")
    end
  end

  describe "with stats" do
    before(:each) do
      @our_stats = assign(:our_stats, [ ["Sigve", 35, 3, 36, 3, 35], ["Christer", 100, 3, 100, 2, 100] ])
      @their_stats = assign(:their_stats, [ ])
    end

    it "renders a stats board" do
      render
      rendered.should have_selector("table.stats")
    end
  end
  
end
