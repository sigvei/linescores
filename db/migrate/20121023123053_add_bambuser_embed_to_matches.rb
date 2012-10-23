class AddBambuserEmbedToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :bambuser_id, :string
  end
end
