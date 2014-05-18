class DropColors < ActiveRecord::Migration
  def up
    drop_table :colors
  end

  def down
    create_table :colors do |t|
      t.string :name
      t.boolean :visible, default: true
    end

    InternalColor.all.each do |c|
      Color.create(name: c.name )
    end    
  end
end
