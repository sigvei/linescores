require 'spec_helper'

describe "matches/new" do
  before(:each) do
    assign(:match, stub_model(Match,
      :opponent => "MyString",
      :location => "MyString",
      :tournament => "MyString"
    ).as_new_record)
  end

  it "renders new match form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => matches_path, :method => "post" do
      assert_select "input#match_opponent", :name => "match[opponent]"
      assert_select "input#match_location", :name => "match[location]"
      assert_select "input#match_tournament", :name => "match[tournament]"
    end
  end
end
