class AddThumbImgToAds < ActiveRecord::Migration
  def change
    add_column :ads, :thumb_img, :string
    add_column :ads, :source_url, :string
    add_column :ads, :title, :string
  end
end
