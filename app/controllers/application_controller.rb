class ApplicationController < ActionController::Base
  protect_from_forgery

  def get_shots_stats(shots)
    if shots.size > 0
      begin
        require 'rserve/simpler/R'

        shots.delete_if{|s| s.call == "X"}

        data = {
          player: shots.map(&:player),
          turn:   shots.map(&:turn),
          call:   shots.map(&:call),
          type:   shots.map{|s| s.call.in?(Shot::DRAWS) ? "Draws" : "Takeouts"},
          score:  shots.map(&:success),
          rock:   shots.map(&:rock)
        }


        R.command(df: data.to_dataframe) do
          "ddf <- with(df, aggregate(score, by=list(player=player, type=type), FUN=mean))"
        end
        ret = R.converse("reshape(ddf, idvar='player', timevar='type', direction='wide')")
        stats = ret.transpose
      rescue LoadError
        nil
      end
    end
  end
end
