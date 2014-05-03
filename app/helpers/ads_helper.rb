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
    ad.year_format ? JalaliDate.new(ad.year).year : ad.year.year 
  end

  def girbox_human ad
    ad.girbox? ? GIRBOX_ARR[ (ad.girbox ? 1 : 0)] : "-"
  end

  def color_human color_id
    color_id.present? ? COLORS[color_id] : "-"
  end

  def usage_type_human ad
    ad.usage_type.present? ? USAGE_ARR[ ad.usage_type ] : "-"
  end

  def fuel_human ad
    ad.fuel.present? ? FUEL_ARR[ ad.fuel ] : "-"
  end

  def ad_show_car_detail_row title, val
    html = <<-HTML
      <div class="row">
        <div class="col-xs-4">#{t title}</div>
        <div class="col-xs-8">#{val}</div>
      </div>
    HTML
    html.html_safe 
  end

end
