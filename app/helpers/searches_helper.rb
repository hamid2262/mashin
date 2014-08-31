module SearchesHelper

  def ad_description ad
    txt = ""
    txt = ad.body_color_name+"، " if ad.body_color_name.present?
    txt = txt + GIRBOX_ARR[ (ad.girbox ? 1 : 0)]+"، " if ad.girbox?
    txt = txt + FUEL_ARR[ ad.fuel ]+"، " if ad.fuel and (ad.fuel > 0)
    txt = txt + USAGE_ARR[ ad.usage_type ]+"، " if ad.usage_type and (ad.usage_type > 0)
    txt + ad.details unless ad.details == "-"    
  end

  def truncate_details ad, length=60
    txt = ""
    txt = "<span itemprop=color> #{ad.body_color_name}</span>"+"، " if ad.body_color_name.present?
    txt = txt + GIRBOX_ARR[ (ad.girbox ? 1 : 0)]+"، " if ad.girbox?
    txt = txt + FUEL_ARR[ ad.fuel ]+"، " if ad.fuel and (ad.fuel > 0)
    txt = txt + USAGE_ARR[ ad.usage_type ]+"، " if ad.usage_type and (ad.usage_type > 0)
    txt = txt + ad.details unless ad.details == "-"    
    truncate_html(txt, length: length, separator:' ')
  end

  def remove_filter_buttun val, klass=""
    html = "<span class=\"tooltip_bottom remove_filter "
    html = html + "myhide" if val.blank?
    html = html + " data-toggle=\"tooltip\" data-placement=\"bottom\" title=\"#{t"remove_filter"}\"\"</span>"
    html.html_safe 
  end

  def with_value_class val
    "with_value" if val.present?
  end

  def appropriate_filter_row_name val, name
    if name == "fuel"
      FUEL_ARR[val]
    elsif name == "girbox"
      GIRBOX_ARR[val ? 1 : 0]
    else
      val.present? ? val : "گوناگون"
    end
  end

  def extract_city location
    location.split(",").first
  end


end
