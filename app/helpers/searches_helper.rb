module SearchesHelper

  def truncate_details ad
    txt = ""
    txt =       ad.body_color_name+"، " if ad.body_color_name.present?
    txt = txt + GIRBOX_ARR[ (ad.girbox ? 1 : 0)]+"، " if ad.girbox?
    txt = txt + FUEL_ARR[ ad.fuel ]+"، " if ad.fuel and (ad.fuel > 0)
    txt = txt + USAGE_ARR[ ad.usage_type ]+"، " if ad.usage_type and (ad.usage_type > 0)
    txt = txt + truncate(ad.details, length: 27, separator: ' ') unless ad.details == "-"
    txt
  end

  def thumb_image ad
    if ad.user_id.nil?                                 # from other sites
      
      if ad.ad_other_field.thumb_img.present?          # if in other site ad has thumbnail
        url = ad.ad_other_field.thumb_img        
      elsif ad.image_urls.first 
        url = ad.image_urls.first.url
      else
        url = IMAGES_PATH+"default_auto_thumb.gif"
      end

    else                                                 #from our web site
      
    end
    image_tag(url, class: "img-responsive")
  end

end
