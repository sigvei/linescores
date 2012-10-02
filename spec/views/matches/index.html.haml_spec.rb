require 'spec_helper'

describe "matches/index" do
  before(:each) do
    assign(:matches, [
      stub_model(Match,
        :id => 1,
        :opponent => "Opponent 1",
        :location => "Location",
        :tournament => "Tournament",
        :time => DateTime.new(2012,1,1,15,0,0)
      ),
      stub_model(Match,
        :id => 2,
        :opponent => "Opponent 2",
        :location => "Location",
        :tournament => "Tournament",
        :time => DateTime.new(2011,1,1,15,0,0)
      )
    ])
  end

  it "renders a list of matches" do
    render
    expect(view).to render_template("index")
    expect(rendered).to have_css("#match_1 .opponent") 
    expect(rendered).to have_css("#match_2 .opponent") 
    expect(rendered).to have_content("Opponent 1")
    expect(rendered).to have_content("Opponent 2")
  end
end
