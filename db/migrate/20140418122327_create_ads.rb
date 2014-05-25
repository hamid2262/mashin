class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.belongs_to :user, index: true
      t.belongs_to :car_model
      t.belongs_to :make

      t.belongs_to :body_color
      t.belongs_to :internal_color
      t.belongs_to :scrap

      t.string   :location
      t.float    :latitude
      t.float    :longitude

      t.date     :year
      t.boolean  :year_format # shamsi=true miladi=false

      t.decimal  :price
      t.integer  :millage
      t.integer  :fuel # benzin = 0, dogane = 1, gasoil = 2
      t.integer  :usage_type, default: 10 # karkarde =0, sefr: 1, havale: 2
      t.boolean  :girbox, default: false
      t.boolean  :active, default: false
      t.text     :details

      t.timestamps
    end

  end
end