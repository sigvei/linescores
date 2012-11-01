class ApplicationController < ActionController::Base
  protect_from_forgery

  def get_shots_stats(shots, sortorder=nil)
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
          %Q{
            separate <- with(df, aggregate(score, by=list(player=player, type=type), FUN=mean))
            separate_n <- with(df, aggregate(score, by=list(player=player, type=paste(type, ' #')), FUN=length))
            totals   <- with(df, aggregate(score, by=list(player=player, type=rep('Total', nrow(df))), FUN=mean))
            ddf <- rbind(separate, separate_n, totals)
          }
        end
        stats = R.converse("reshape(ddf[order(ddf$type),], idvar='player', timevar='type', direction='wide')")
        if stats.first.is_a? String
          [ stats ]
        else
          stats = stats.transpose

          if sortorder
            stats.sort_by! do |row|
              sortorder.index(row[0]) || -1
            end
          end
        end

        # Fix string encoding in first column
        stats.map! do |row|
          [ row[0].force_encoding("UTF-8") ] + row[1..-1]
        end

        stats
      rescue LoadError
        nil
      end
    end
  end

  protected

  def authenticate
    authenticate_or_request_with_http_digest do |username|
      get_users[username]
    end
  end

  private

  def get_users
    begin
      YAML.load_file("#{Rails.root}/config/users.yml")
    rescue
      { }
    end
  end
end
