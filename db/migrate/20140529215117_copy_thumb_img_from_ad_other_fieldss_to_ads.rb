class CopyThumbImgFromAdOtherFieldssToAds < ActiveRecord::Migration
  def up
    Ad.all.each do |ad|     
      ad.source_url = ad.ad_other_field.source_url
      ad.title      = ad.ad_other_field.title
      ad.thumb_img  = ad.ad_other_field.thumb_img
      ad.save
    end
    remove_column :ad_other_fields, :source_url
    remove_column :ad_other_fields, :title
    remove_column :ad_other_fields, :thumb_img
  end

  def down
    add_column    :ad_other_fields, :source_url, :string
    add_column    :ad_other_fields, :title, :string
    add_column    :ad_other_fields, :thumb_img, :string

    Ad.all.each do |ad| 
      ad.ad_other_field.source_url = ad.source_url 
      ad.ad_other_field.title      = ad.title 
      ad.ad_other_field.thumb_img  = ad.thumb_img 
      ad.save
    end
  end

end
