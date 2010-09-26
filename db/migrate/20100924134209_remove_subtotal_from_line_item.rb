class RemoveSubtotalFromLineItem < ActiveRecord::Migration
  def self.up
	  remove_column :line_items, :subtotal
  end

  def self.down
	  add_column :line_items, :subtotal, :integer
  end
end
