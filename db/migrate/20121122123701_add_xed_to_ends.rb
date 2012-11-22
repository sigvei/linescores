class AddXedToEnds < ActiveRecord::Migration
  def change
    add_column :ends, :xed, :boolean
  end
end
