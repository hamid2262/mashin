module AdsHelper

	  def human_fuel fuel
  	case fuel
  	when 0
  		t ("benzin")
  	when 1
  		"hibrid"
  	when 2
  		"gasoil"
  	end  		
  end

  def usage usage_type
  	case usage_type
  	when 0
  		"used"
  	when 1
  		"new"
  	when 2
  		"havale"
  	end  		
  end

  def appropriate_year(ad)
    if ad.year
      if ad.year_format==true
        JalaliDate.new(ad.year).year
      else
        ad.year.year 
      end
    end
  end

  def girbox_human ad
    GIRBOX_ARR[ (ad.girbox ? 1 : 0)]
  end

  def usage_type_human ad
    ad.usage_type.present? ? USAGE_ARR[ ad.usage_type ] : "-"
  end

  def damaged_human ad
    ad.damaged.present? ? DAMAGED[ ad.damaged ] : "-"
  end

  def fuel_human ad
    ad.fuel.present? ? FUEL_ARR[ ad.fuel ] : "-"
  end

  def ad_show_car_detail_row col1=4, col2=8, title, val
    if val.present?
      html = <<-HTML
        <div class="row">
          <div class="col-xs-#{col1}">#{t title}</div>
          <div class="col-xs-#{col2}">#{val}</div>
        </div>
      HTML
      html.html_safe 
    end
  end

  def ad_image ad, img, style=:medium
    if ad.user_id.nil?
      image_tag img.url, class: "img-responsive", alt: "#{t"sell"} #{t"vehicle"} #{img.ad.make_name} #{img.ad.car_model_name}"
    else
      image_tag img.name.url(style), class: "img-responsive", alt: "#{t"sell"} #{t"vehicle"} #{img.ad.make_name} #{img.ad.car_model_name}"
    end
  end
  
  def ad_thumb ad, img
    if ad.user_id.nil?
      image_tag img.url, class: "img-responsive", alt: "#{t"sell"} #{t"vehicle"} #{img.ad.make_name} #{img.ad.car_model_name}"
    else
      image_tag img.name.url(:thumb), class: "img-responsive", alt: "#{t"sell"} #{t"vehicle"} #{img.ad.make_name} #{img.ad.car_model_name}"
    end
  end
  
  def ad_tel ad
    if ad.ad_other_field.source_url and ad.ad_other_field.source_url.include? "takhtegaz.com"
      return link_to t("see_from_reference"), ad.ad_other_field.source_url, target: "_blank"
    else
      ad.ad_other_field.tel  
    end
  end
end
