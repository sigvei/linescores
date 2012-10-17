class AddFirstHammerToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :our_first_hammer, :boolean
  end
end
