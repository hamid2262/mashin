class CopyThumbImgFromAdOtherFieldssToAds < ActiveRecord::Migration
  def up
    # execute "update ads set followers_count=(select count(*) from following_relationships where followed_user_id=users.id)"
    execute "update ads set source_url=(select source_url from ad_other_fields where ad_other_fields.ad_id=ads.id),\
                                 title=(select title from ad_other_fields where ad_other_fields.ad_id=ads.id),\
                                 thumb_img=(select thumb_img from ad_other_fields where ad_other_fields.ad_id=ads.id)"
    remove_column :ad_other_fields, :source_url
    remove_column :ad_other_fields, :title
    remove_column :ad_other_fields, :thumb_img
  end

  def down
    execute "update ads set source_url=NULL,\
                                 title=NULL,\
                                 thumb_img=NULL"
    add_column    :ad_other_fields, :source_url, :string
    add_column    :ad_other_fields, :title, :string
    add_column    :ad_other_fields, :thumb_img, :string
  end
end
