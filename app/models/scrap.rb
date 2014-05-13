class Scrap < ActiveRecord::Base
  belongs_to :site
  has_many   :ads

  def sweep
    @terminate = false
    begin 
      doc = Nokogiri::HTML(open(self.url))
      single_page_sweep(doc)
      break if @terminate 
    end while true 
  end

private
  
  def single_page_sweep(doc)
    if doc.css('.ads').any?
      doc.css('.ads').each do |row|
        # sleep 7
        delete_path = row.at_css(".base_fields .show a")["href"]
        if skip_condition? row
          open(delete_path) # just for deletation
          next
        end
        @ad_hash = {}
        extract_base_fields(row)
        ad = create_ad
        extract_other_fields(row)
        build_ad_other_field_record(ad)
        extract_and_build_images(ad, row)
        open(delete_path) # just for deletation
      end
    else
      @terminate = true
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
  end

  def extract_other_fields(row)
    @ad_hash[:title]      = title row
    @ad_hash[:tel]        = tel row
    @ad_hash[:thumb_img]  = thumb_img row
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
        title:       @ad_hash[:title],
        source_url:  @ad_hash[:source_url],
        thumb_img:   @ad_hash[:thumb_img],
        tel:         @ad_hash[:tel]
      )
      ad.save  
  end

  def create_ad 
      ad = self.ads.build(
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
        active:            true
      )
      ad.save
      ad
  end

  def skip_condition? row
    flag = false
    url = row.css('.source_url').text
    flag = true if url.blank?
    flag = true if AdOtherField.where(source_url: url).first
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
    body_color = Color.find_or_create_by(name: body_color_name)
    body_color.id
  end

  def internal_color_id row
    internal_color_name = row.at_css(".base_fields .internal_color").text
    internal_color = Color.find_or_create_by(name: internal_color_name)
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

end
