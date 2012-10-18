class EndsController < ApplicationController
  before_filter :get_match

  def show
    edit
  end

  def edit
    @end = @match.ends.find(params[:id])

    generate_missing_shots
  end

  def update
    @end = @match.ends.find(params[:id])

    respond_to do |format|
      if @end.update_attributes(params[:end])
        format.html { redirect_to @match, notice: 'End was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { 
          generate_missing_shots
          render action: "edit" 
        }
        format.json { render json: @end.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def get_match
    @match = Match.find(params[:match_id])
  end

  def generate_missing_shots
    # Auto-generate stubs for 8x2 shots
    %w(us them).each do |team|
      (1..8).each do |rock|
        unless @end.shots.detect{|s| s.team == team && s.rock == rock}
          ourtheir = (team == "us") ? :our : :their
          pn = @match.player_name(ourtheir, @match.default_player(rock, ourtheir))
          @end.shots.build(:team => team, :rock => rock, :player => pn)
        end
      end
    end
  end
end
