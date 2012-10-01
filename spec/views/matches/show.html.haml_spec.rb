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
end
