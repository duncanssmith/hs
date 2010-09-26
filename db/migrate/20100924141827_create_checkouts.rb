class CreateCheckouts < ActiveRecord::Migration
  def self.up
    create_table :checkouts do |t|
      t.integer :basket_id
      t.integer :subtotal
      t.integer :savings
      t.integer :total

      t.timestamps
    end
  end

  def self.down
    drop_table :checkouts
  end
end
