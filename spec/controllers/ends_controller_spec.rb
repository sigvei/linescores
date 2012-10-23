require 'spec_helper'

describe EndsController do
  before(:each) do
    @match = FactoryGirl.create(:match)
    @end = FactoryGirl.create(:end, :match => @match)
    ApplicationController.any_instance.stub(:authenticate)
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', :match_id => @match.id, :id => @end.id
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', :match_id => @match.id, :id => @end.id
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    it "returns http success" do
      put 'update', :match_id => @match.id, :id => @end.id
      response.should be_redirect
    end
  end

end
