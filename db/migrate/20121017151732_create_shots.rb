class CreateShots < ActiveRecord::Migration
  def change
    create_table :shots do |t|
      t.integer :end_id
      t.string :team
      t.integer :rock
      t.string :call
      t.string :turn
      t.integer :success
      t.string :player

      t.timestamps
    end
  end
end
