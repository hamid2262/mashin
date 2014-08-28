class Scrap < ActiveRecord::Base
  belongs_to :site
  has_many   :ads

  def sweep
    doc = Nokogiri::HTML(open(self.url))
    single_page_sweep(doc)
  end

private
  def single_page_sweep(doc)
    if doc.css('.ads').any?
      doc.css('.ads').each do |row|
        delete_path = row.at_css(".base_fields .show a")["href"]
        if skip_condition? row
          open(delete_path) # just for deletation
          next
        end
        @ad_hash = {}
        extract_base_fields(row)
        ad = create_ad
        if ad.nil?
          open(delete_path) # just for deletation
          next
        end
        extract_other_fields(row)
        build_ad_other_field_record(ad)
        extract_and_build_images(ad, row)
        # extract_car_info if self.url == "http://bama1.herokuapp.com/ads"
        open(delete_path) # just for deletation
      end
    end
  end

  def extract_car_info
    doc = Nokogiri::HTML(open(@ad_hash[:source_url]))
    info_path = doc.at_css("#ctl00_cphMain_SelectedAdInfo1_hlkDetailInfo")
    if info_path
      info_path = info_path["href"]
      fill_car_info(info_path) 
    end
  end

  def extract_base_fields(row)
    @ad_hash[:make_id]           = make row
    @ad_hash[:car_model_id]      = car_model row
    @ad_hash[:body_color_id]     = body_color_id row
    @ad_hash[:internal_color_id] = internal_color_id row

    @ad_hash[:location]    = location row
    loc = extract_lat_lng(@ad_hash[:location])
    @ad_hash[:latitude]    = loc[:latitude]
    @ad_hash[:longitude]   = loc[:longitude]

    @ad_hash[:year]        = year row
    @ad_hash[:year_format] = year_format row
    @ad_hash[:price]       = price row
    @ad_hash[:millage]     = millage row
    @ad_hash[:details]     = details row
    @ad_hash[:fuel]        = fuel row
    @ad_hash[:usage_type]  = usage_type row
    @ad_hash[:girbox]      = girbox row
    @ad_hash[:thumb_img]  = thumb_img row
    @ad_hash[:title]      = title row
    @ad_hash[:source_url] = source_url row
  end

  def extract_other_fields(row)
    @ad_hash[:tel]        = tel row
    @ad_hash[:source_url] = source_url row
  end

  def extract_and_build_images(ad, row)
    row.css(".images .image").each do |tag|
      ad.image_urls.build( url:  tag.text)
      ad.save 
    end
    
  end


  def build_ad_other_field_record ad
      ad.build_ad_other_field(
        source_url:  @ad_hash[:source_url],
        tel:         @ad_hash[:tel]
      )
      ad.save  
  end

  def create_ad 
    begin
      ad = Ad.create!(
        make_id:           @ad_hash[:make_id], 
        car_model_id:      @ad_hash[:car_model_id], 
        price:             @ad_hash[:price], 
        year:              @ad_hash[:year], 
        year_format:       @ad_hash[:year_format], 
        details:           @ad_hash[:details], 
        girbox:            @ad_hash[:girbox], 
        millage:           @ad_hash[:millage],
        fuel:              @ad_hash[:fuel],
        usage_type:        @ad_hash[:usage_type],
        body_color_id:     @ad_hash[:body_color_id],
        internal_color_id: @ad_hash[:internal_color_id],
        location:          @ad_hash[:location],
        latitude:          @ad_hash[:latitude], 
        longitude:         @ad_hash[:longitude], 
        thumb_img:         @ad_hash[:thumb_img],
        title:             @ad_hash[:title],
        source_url:        @ad_hash[:source_url],
        status:            2
      )
    rescue
      return nil
    end
    ad
  end

  def skip_condition? row
    flag = false
    url = row.css('.source_url').text
    flag = true if url.blank?
    ad_others = AdOtherField.where(source_url: url).first
    if ad_others
      ad_others.ad.destroy
    end
    flag
  end

  ###################################
  def make row
    if row.at_css(".other_fields .scrap_name").text == "tejarat"
      title = extract_make_and_car_model_for_tejarat row
      Make.all.each do |make|
        return make.id if title.include? make.name
      end
      nil
    else
      make_name = row.at_css(".base_fields .make").text
      make = Make.find_or_create_by(name: make_name)
      make.id
    end
  end

  def car_model row
    if row.at_css(".other_fields .scrap_name").text == "tejarat"
      return nil if @ad_hash[:make_id].nil?
      title = extract_make_and_car_model_for_tejarat row
      make = Make.find @ad_hash[:make_id]
      make.car_models.each do |car_model|
        return car_model.id  if title.include? car_model.name
      end
      car_model_name = title.gsub(make.name, "").strip
      car_model = CarModel.find_by(name: car_model_name)
      unless car_model
        car_model = CarModel.create(name: car_model_name, make_id: make.id)
      end    
    else
      car_model_name = row.at_css(".base_fields .car_model").text
      car_model = CarModel.find_by(name: car_model_name)
      unless car_model
        car_model = CarModel.create(name: car_model_name, make_id: make(row))
      end    
    end
    car_model.id
  end

  def extract_make_and_car_model_for_tejarat row
    title = row.at_css(".other_fields .title").text
    title = title.gsub("فروش", "")
    if title.index "مدل"
      index = title.index "مدل"
    elsif title.index "صفرکیلومتر"
      index = title.index "صفرکیلومتر"
    end
    title[1,index-2]    
  end

  def price row
    price = row.at_css(".base_fields .price").text
    price.to_f
  end

  def millage row
    millage = row.at_css(".base_fields .millage").text
    millage.to_f
  end

  def details row
    row.at_css(".base_fields .details").text
  end

  def girbox row
    girbox = row.at_css(".base_fields .girbox").text
    (girbox == "true") ? true : false
  end

  def fuel row
    fuel = row.at_css(".base_fields .fuel").text
    fuel.to_i    
  end

  def body_color_id row
    body_color_name = row.at_css(".base_fields .body_color").text
    body_color = BodyColor.find_or_create_by(name: body_color_name)
    body_color.id
  end

  def internal_color_id row
    internal_color_name = row.at_css(".base_fields .internal_color").text
    internal_color = InternalColor.find_or_create_by(name: internal_color_name)
    internal_color.id
  end

  def location row
    row.at_css(".base_fields .location").text
  end

  def year row
    year = row.at_css(".base_fields .year").text
    year.to_date
  end

  def year_format row
    year_format = row.at_css(".base_fields .year_format").text
    (year_format == "true") ? true : false
  end

  def usage_type row    
    usage_type = row.at_css(".base_fields .usage_type").text
    usage_type.to_i
  end

  def tel row
    row.at_css(".other_fields .tel").text
  end

  def title row
    row.at_css(".other_fields .title").text
  end

  def source_url row
    row.at_css(".other_fields .source_url").text
  end

  def thumb_img row
    row.at_css(".other_fields .thumb_img").text
  end

  def extract_lat_lng location
    l = {}
    myloc = Location.where(name: location).first
    if myloc && myloc.latitude
      lat = myloc.latitude
      lng = myloc.longitude
    else
      loc = Geocoder.search(location)[0]
      lat = loc.try(:latitude)
      lng = loc.try(:longitude)
      Location.create(name: location, latitude: lat, longitude: lng)  if lng
    end
    l[:latitude]  = lat
    l[:longitude] = lng
    l
  end

#########################################
  def fill_car_info info_path
    url = info_path.split "/"
    make_slug = url[4]
    car_model_slug = url[5]
    year = url[6]
    fill_make_slug make_slug
    fill_car_model_slug car_model_slug

    if @make and @car_model 
      build_year = BuiltYear.where(year: year, make_id: @make.id, car_model_id: @car_model.id).first      
      fill_built_year_slug info_path, year unless build_year
    end
  end

  def fill_make_slug make_slug
    @make = Make.find_by(id: @ad_hash[:make_id]) 
    if @make and @make.slug==nil
       @make.slug = make_slug
       @make.save
    end 
  end

  def fill_car_model_slug car_model_slug
    @car_model = CarModel.find_by(id: @ad_hash[:car_model_id]) 
    if @car_model and @car_model.slug==nil
       @car_model.slug = car_model_slug
       @car_model.save
    end 
  end

  def fill_built_year_slug info_path, year
    @car_info = {}
    doc = Nokogiri::HTML(open(info_path))
    sweep_car_info doc
    create_built_year year
  end

  def sweep_car_info doc
    img =  doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_rptBrandModelYear1_ctl00_imgCarImage1")["src"]
    @car_info[:image] =  img.sub "../../..", "http://www.bama.ir"

    @car_info[:gearbox] =          doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblGirboxType1").text
    @car_info[:diff] =             doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblDiffType1").text
    @car_info[:engine_displacement] = doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblHajmeMotor1").text.to_i
    @car_info[:cylinder] =         doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblSilanderNo1").text.to_i
    @car_info[:soupape] =          doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblSupopNo1").text.to_i

    @car_info[:power] =            doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblPowerV1").text
    @car_info[:torque] =           doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblGashtavarV1").text

    @car_info[:length] =           doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblLength1").text.to_i
    @car_info[:width] =            doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblWidth1").text.to_i
    @car_info[:height] =           doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblHeight1").text.to_i

    @car_info[:speed] =            doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblMaxSorat1").text.to_i
    @car_info[:acceleration] =     doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblShetab0To1001").text.to_f
    
    @car_info[:fuel_consumption] = doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblMasrafOil1").text.to_f    
    @car_info[:tank_size] =        doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblHajmeOil1").text.to_i

    @car_info[:tire] =             doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblTairSize").text
    @car_info[:emission_standards] = doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblEmissionStandard").text
    
    @car_info[:airbag] =           doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblAirBack1").text
    @car_info[:brake] =            doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblTurmooz1").text
    @car_info[:tahvie_hava] =      doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblTahveeHava1").text
    @car_info[:seats] =            doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblSandaly1").text
    @car_info[:shisheha] =         doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblShisheha1").text
    @car_info[:ayneha] =           doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblAyneha1").text
    @car_info[:cheraghha] =        doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblCheraghha1").text
    @car_info[:other_facilities] = doc.at_css("#ctl00_cphMain_VehicleDetailInfo1_lblOthers1").text 
  end

  def create_built_year  year
    BuiltYear.create!(
      year:                year,
      make_id:             @make.id, 
      car_model_id:        @car_model.id,
      image:               @car_info[:image], 
      gearbox:             @car_info[:gearbox], 
      diff:                @car_info[:diff], 
      engine_displacement: @car_info[:engine_displacement], 
      cylinder:            @car_info[:cylinder], 
      soupape:             @car_info[:soupape],
      power:               @car_info[:power],
      torque:              @car_info[:torque],
      length:              @car_info[:length],
      width:               @car_info[:width],
      height:              @car_info[:height],
      speed:               @car_info[:speed], 
      acceleration:        @car_info[:acceleration], 
      fuel_consumption:    @car_info[:fuel_consumption],
      tank_size:           @car_info[:tank_size],
      tire:                @car_info[:tire],
      emission_standards:  @car_info[:emission_standards],
      airbag:              @car_info[:airbag],
      brake:               @car_info[:brake],
      tahvie_hava:         @car_info[:tahvie_hava],
      seats:               @car_info[:seats],
      shisheha:            @car_info[:shisheha],
      ayneha:              @car_info[:ayneha],
      cheraghha:           @car_info[:cheraghha],
      other_facilities:    @car_info[:other_facilities]
    )
  end


end
