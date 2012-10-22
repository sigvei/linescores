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

        R.command("library(reshape)")
        ret = R.converse("reshape(aggregate(score ~ player + type, df, mean), idvar=c('player'), timevar='type', direction='wide')", df: data.to_dataframe)
        ret.transpose
      rescue LoadError
        nil
      end
    end
  end
end
