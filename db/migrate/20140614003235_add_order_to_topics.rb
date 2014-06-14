class AddOrderToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :order, :integer
    add_index :topics, :order
  end
end
