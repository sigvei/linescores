require 'spec_helper'

describe "matches/index" do
  before(:each) do
    assign(:matches, [
      stub_model(Match,
        :opponent => "Opponent",
        :location => "Location",
        :tournament => "Tournament"
      ),
      stub_model(Match,
        :opponent => "Opponent",
        :location => "Location",
        :tournament => "Tournament"
      )
    ])
  end

  it "renders a list of matches" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Opponent".to_s, :count => 2
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => "Tournament".to_s, :count => 2
  end
end
