class CreateBodyColors < ActiveRecord::Migration
  def change
    create_table :body_colors do |t|
      t.string :name
      t.boolean :visible, default: true

      t.timestamps
    end
    Color.all.each do |c|
      BodyColor.create(name: c.name )
    end
  end
end
