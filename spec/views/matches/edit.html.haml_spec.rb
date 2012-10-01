require 'spec_helper'

describe "matches/edit" do
  before(:each) do
    @match = assign(:match, stub_model(Match,
      :opponent => "MyString",
      :location => "MyString",
      :tournament => "MyString"
    ))
  end

  it "renders the edit match form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => matches_path(@match), :method => "post" do
      assert_select "input#match_opponent", :name => "match[opponent]"
      assert_select "input#match_location", :name => "match[location]"
      assert_select "input#match_tournament", :name => "match[tournament]"
    end
  end
end
