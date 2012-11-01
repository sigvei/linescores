class MatchesController < ApplicationController
  before_filter :sanitize_params, :only => [:update, :create]
  before_filter :authenticate, :except => [:index, :show]
  # GET /matches
  # GET /matches.json
  def index
    @matches = Match.order("time DESC").all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @matches }
      format.ics do
        cal = RiCal.Calendar do |cal|
          @matches.each do |m|
            if m.time
              cal.event do |event|
                event.summary       = m.to_summary
                event.description   = m.to_description
                event.dtstart       = m.time
                event.dtend         = m.time + 2.hours
                event.location      = m.location
                event.created       = m.created_at
                event.last_modified = m.updated_at
                event.uid           = m.uid
              end
            end
          end
        end
        render text: cal.export
      end
    end
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
    @match = Match.find(params[:id])
    @our_stats = get_player_stats(@match.shots.ours.completed, @match.our_lineup) || []
    @their_stats = get_player_stats(@match.shots.theirs.completed, @match.their_lineup) || []

    @end_by_end = get_end_by_end_stats(@match.shots.completed) || []

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @match }
    end
  end

  # GET /matches/new
  # GET /matches/new.json
  def new
    @match = Match.new
    12.times { @match.ends.build }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @match }
    end
  end

  # GET /matches/1/edit
  def edit
    @match = Match.find(params[:id])
    until @match.ends.size == 12
      @match.ends.build
    end
  end

  # POST /matches
  # POST /matches.json
  def create
    @match = Match.new(params[:match])

    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: 'Match was successfully created.' }
        format.json { render json: @match, status: :created, location: @match }
      else
        format.html { render action: "new" }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /matches/1
  # PUT /matches/1.json
  def update
    @match = Match.find(params[:id])

    respond_to do |format|
      if @match.update_attributes(params[:match])
        format.html { redirect_to @match, notice: 'Match was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    respond_to do |format|
      format.html { redirect_to matches_url }
      format.json { head :no_content }
    end
  end

  private

  def sanitize_params
    %w(our_skip their_skip our_viceskip their_viceskip).each do |fld|
      if params[:match][fld] == "on"
        params[:match][fld] = nil
      end
    end
  end
end
