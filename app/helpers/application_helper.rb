module ApplicationHelper

	def flash_creator flash
		message= "";
		flash.each do |name, msg| 	
			case name
				when :notice    
				  message += "<div class=\"alert alert-success\">#{msg}</div>"	
				when :warning    
				  message += "<div class=\"alert alert-warning\">#{msg}</div>"	
				when :error, :alert
				  message += "<div class=\"alert alert-danger\">#{msg}</div>"
				else
				  message += "<div class=\"alert alert-info\">#{msg}</div>"			
			end
	 	end 
	 	message.html_safe
	end

  def cached_makes_for_select
    Rails.cache.fetch([:select_makes], expires_in: 120.minutes) do 
      option_groups_from_collection_for_select(
        Make.for_menus, 
        :deligated_car_models, 
        :name, 
        :id, 
        :name
      )
    end
  end

  def km_range
  	a = (1000..10000).step(1000).map{|s| [ ("#{number_to_human s} #{t("kilometer")}") , s]}
  	b = ((20000..100000).step(10000)).map{|s| [("#{number_to_human s} #{t("kilometer")}") , s]}
  	c = ((200000..1000000).step(100000)).map{|s| [("#{number_to_human s} #{t("kilometer")}") , s]}

  	a.concat(b).concat(c)
  end

  def price_range
    unit = 1000000.0
  	a = ( ( (unit*1   )..(unit*10  ) ).step(unit*1)    ).map{|s| [("#{number_to_human s} #{t("toman")}") , s]}
  	b = ( ( (unit*20  )..(unit*100 ) ).step(unit*10)   ).map{|s| [("#{number_to_human s} #{t("toman")}") , s]}
    c = ( ( (unit*200 )..(unit*1000) ).step(unit*100)  ).map{|s| [("#{number_to_human s} #{t("toman")}") , s]}
  	d = ( ( (unit*2000)..(unit*5000) ).step(unit*1000) ).map{|s| [("#{number_to_human s} #{t("toman")}") , s]}

  	a.concat(b).concat(c).concat(d)
  end

  def year_range format="shamsi"
    a = [[ "", ""]]
    if format == "shamsi"
      this_year = JalaliDate.new(Date.today).year
      b = ( (this_year).downto(this_year-70) ).map{|s| [ s, s+621]}   
    else
      this_year = Date.today.year
      b = ( (this_year).downto(this_year-70) ).map{|s| [ s, s]}    
    end
    a.concat b
  end

  def error_messages_for(object)
    render(:partial => 'application/error_messages',
      :locals => {:object => object})
  end

  def price_human amount
    (amount != 0) ? number_to_human(amount, precision: 4, separator: "/")  : t("undifinded")
  end

  def date_human date
    # if date > DateTime.now - 24.hours
    #   t "today"
    # else
      "#{time_ago_in_words(date) } #{t("ago")}"
    # end
  end

  def last_search
    cookies[:last_search] ? Search.find( cookies[:last_search]) : root_url
  end

  def title_creator search
    title = "خرید و فروش خودرو "
    title = title + " #{search.make.name}"  if search.make_id
    title = title + " #{search.car_model.name}" if search.car_model_id     
    title
  end

  def ad_title ad
    if ad.user or (ad.make_id and ad.source_url and ad.source_url.include? "www.bama.ir") 
      title = " "
      title = "<span class='pull-right title_element'>#{ad.make_name}، &nbsp;</span>"  if ad.make_name
      title = title + " <span class='pull-right title_element'>#{ad.car_model_name}،&nbsp;</span>" if ad.car_model_name.present?     
      title = title + " <span class='pull-right title_element'>#{appropriate_year(ad) }</span> <br>" if ad.year or ad.usage_type==1           
    else
      title = ad.title
      title.gsub! "فروش", "" if title
      title.gsub! "مدل", " ،" if title
    end
    title.try(:html_safe)
  end

  def thumb_image ad
      if ad.thumb_img.present?          # if in other site ad has thumbnail
        thumb = ad.thumb_img        
      else
        if ad.user_id                                 
          images = ad.images
          thumb = images.first.name.url(:thumb) if images.any?
        end
      end

    thumb = IMAGES_PATH+"default_auto_thumb.gif" unless thumb
    image_tag(thumb, class: "img-responsive")
  end


  def user_form_control_static title, field_value, klass1="col-xs-3", klass2="col-xs-9"
    field_value = t('no_data') if field_value.blank?
    html = <<-HTML
      <div class="form-group">
        <label class="#{klass1} control-label">#{title}</label>
        <div class="#{klass2}">
          <p class="form-control-static">
                                    #{field_value}
          </p>
        </div>
      </div>
    HTML
    html.html_safe 
  end

  def t_gender gender
    if gender == 'm'
      t('gender.male')
    else
      t('gender.female')
    end
  end
    
  def two_column_title_value col1=4, col2=8, title, val
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

end
