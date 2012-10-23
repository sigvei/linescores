require 'spec_helper'

describe MatchesController do

  # This should return the minimal set of attributes required to create a valid
  # Match. As you add validations to Match, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { opponent: "Motstander" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MatchesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  before(:each) do
    ApplicationController.any_instance.stub(:authenticate)
  end

  describe "GET index" do
    it "assigns all matches as @matches" do
      match = Match.create! valid_attributes
      get :index, {}, valid_session
      assigns(:matches).should eq([match])
    end

    it "returns an iCalendar file" do
      3.times { FactoryGirl.create :match_with_ends }
      FactoryGirl.create :match
      get :index, {:format => :ics}, valid_session
      assigns(:matches).size.should == 4
      response.body.scan("BEGIN:VEVENT").should have(4).items
    end
  end

  describe "GET show" do
    it "assigns the requested match as @match" do
      match = Match.create! valid_attributes
      get :show, {:id => match.to_param}, valid_session
      assigns(:match).should eq(match)
    end
  end

  describe "GET new" do
    it "assigns a new match as @match" do
      get :new, {}, valid_session
      assigns(:match).should be_a_new(Match)
    end
  end

  describe "GET edit" do
    it "assigns the requested match as @match" do
      match = Match.create! valid_attributes
      get :edit, {:id => match.to_param}, valid_session
      assigns(:match).should eq(match)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Match" do
        expect {
          post :create, {:match => valid_attributes}, valid_session
        }.to change(Match, :count).by(1)
      end

      it "assigns a newly created match as @match" do
        post :create, {:match => valid_attributes}, valid_session
        assigns(:match).should be_a(Match)
        assigns(:match).should be_persisted
      end

      it "redirects to the created match" do
        post :create, {:match => valid_attributes}, valid_session
        response.should redirect_to(Match.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved match as @match" do
        # Trigger the behavior that occurs when invalid params are submitted
        Match.any_instance.stub(:save).and_return(false)
        post :create, {:match => {}}, valid_session
        assigns(:match).should be_a_new(Match)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Match.any_instance.stub(:save).and_return(false)
        post :create, {:match => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested match" do
        match = Match.create! valid_attributes
        # Assuming there are no other matches in the database, this
        # specifies that the Match created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Match.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => match.to_param, :match => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested match as @match" do
        match = Match.create! valid_attributes
        put :update, {:id => match.to_param, :match => valid_attributes}, valid_session
        assigns(:match).should eq(match)
      end

      it "redirects to the match" do
        match = Match.create! valid_attributes
        put :update, {:id => match.to_param, :match => valid_attributes}, valid_session
        response.should redirect_to(match)
      end
    end

    describe "with invalid params" do
      it "assigns the match as @match" do
        match = Match.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Match.any_instance.stub(:save).and_return(false)
        put :update, {:id => match.to_param, :match => {}}, valid_session
        assigns(:match).should eq(match)
      end

      it "re-renders the 'edit' template" do
        match = Match.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Match.any_instance.stub(:save).and_return(false)
        put :update, {:id => match.to_param, :match => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested match" do
      match = Match.create! valid_attributes
      expect {
        delete :destroy, {:id => match.to_param}, valid_session
      }.to change(Match, :count).by(-1)
    end

    it "redirects to the matches list" do
      match = Match.create! valid_attributes
      delete :destroy, {:id => match.to_param}, valid_session
      response.should redirect_to(matches_url)
    end
  end

end
