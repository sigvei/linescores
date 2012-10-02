class CreateEnds < ActiveRecord::Migration
  def change
    create_table :ends do |t|
      t.integer :match_id
      t.integer :position
      t.integer :result

      t.timestamps
    end
  end
end
