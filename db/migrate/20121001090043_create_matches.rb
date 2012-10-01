class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :opponent
      t.datetime :time
      t.string :location
      t.string :tournament

      t.timestamps
    end
  end
end
