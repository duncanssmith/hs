class RemoveTotalFromBasket < ActiveRecord::Migration
  def self.up
		remove_column :baskets, :total
  end

  def self.down
		add_column :baskets, :total, :integer
  end
end
