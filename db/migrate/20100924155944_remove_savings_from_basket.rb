class RemoveSavingsFromBasket < ActiveRecord::Migration
  def self.up
		remove_column :baskets, :savings
  end

  def self.down
		add_column :baskets, :savings, :integer
  end
end
