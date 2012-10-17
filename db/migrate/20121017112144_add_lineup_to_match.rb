class AddLineupToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :our_lead, :string
    add_column :matches, :our_second, :string
    add_column :matches, :our_third, :string
    add_column :matches, :our_fourth, :string
    add_column :matches, :our_alternate, :string
    add_column :matches, :their_lead, :string
    add_column :matches, :their_second, :string
    add_column :matches, :their_third, :string
    add_column :matches, :their_fourth, :string
    add_column :matches, :their_alternate, :string
    add_column :matches, :our_skip, :integer
    add_column :matches, :their_skip, :integer
    add_column :matches, :our_viceskip, :integer
    add_column :matches, :their_viceskip, :integer
  end
end
