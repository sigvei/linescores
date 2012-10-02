class SplitResultIntoOursTheirs < ActiveRecord::Migration
  def up
    add_column :ends, :our_score, :integer
    add_column :ends, :their_score, :integer

    End.all.each do |e|
      e.our_score   = ((e.result || 0) > 0) ? e.result : 0
      e.their_score = ((e.result || 0) < 0) ? e.result.abs : 0
    end

    remove_column :ends, :result
  end

  def down
    add_column :ends, :result, :integer

    End.all.each do |e|
      e.result = e.our_score - e.their_score
    end

    remove_column :ends, :our_score
    remove_column :ends, :their_score
  end
end
