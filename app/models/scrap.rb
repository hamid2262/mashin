class Scrap < ActiveRecord::Base
  belongs_to :site
  has_many   :ads

  def sweep
  	page_num = 1
  	self.count = 0

		begin 
		  url = self.url + "#{page_num}"

			doc = Nokogiri::HTML(open(url))
			single_page_sweep(doc)

		  page_num = page_num +1 
		end while self.count > 5
	end


private
  
	def single_page_sweep(doc)
		
    doc.css('.center a.grid').each do |tag|

      url_single = tag["href"]

      doc_single = Nokogiri::HTML(open(url_single))
      
      next if skip_condition? doc_single, url_single

      ad_hash = single_ad_sweep(doc_single)

      ad = create_ad(ad_hash)

      build_ad_other_field_record(ad, url_single, ad_hash)

      build_ad_images(ad, doc_single)

    end

	end

  def build_ad_images(ad, doc_single)
    doc_single.css('#ctl00_cphMain_SelectedAdImages1_pnlImage div>img.AdImagefader').each do |img|
      url = img["src"].gsub "../..", "http://www.bama.ir"

      build_ad_image(ad, url)
    end
  end

  def build_ad_image(ad, url)
    unless url == "http://www.bama.ir/AdImages/Default-Car-Big.png"
      ad.image_urls.build( url:  url)
      ad.save      
    end
  end

  def build_ad_other_field_record(ad, url_single, ad_hash)
      ad.build_ad_other_field(
        source_url:  url_single,
        tel:         ad_hash[:tel]
      )
      ad.save  
  end

  def create_ad ad_hash
      ad = self.ads.build(
        car_model_id:      ad_hash[:car_model_id],
        price:             ad_hash[:price], 
        year:              ad_hash[:year], 
        details:           ad_hash[:details], 
        girbox:            ad_hash[:girbox], 
        millage:           ad_hash[:millage],
        fuel:              ad_hash[:fuel],
        usage_type:        ad_hash[:usage_type],
        body_color_id:     ad_hash[:body_color_id],
        internal_color_id: ad_hash[:internal_color_id],
        location:          ad_hash[:location],
        latitude:          ad_hash[:latitude], 
        longitude:         ad_hash[:longitude], 
        active: true
      )
      ad.save
      ad
  end

  def skip_condition? doc_single, url_single
    flag = false
    feature = doc_single.css('#ctl00_cphMain_SelectedAdInfo1_lblBrandModelYear')
    if feature.blank?
      flag = true
    end
    flag
  end

	def single_ad_sweep doc_single
    ad_hash = {}

    ad_hash[:tel] = tel doc_single

    ad_hash[:price] = price doc_single

    ad_hash[:millage] = millage doc_single

    ad_hash[:details] = details doc_single

    ad_hash[:girbox] = girbox doc_single

    ad_hash[:fuel] = fuel doc_single

    ad_hash[:body_color_id] = body_color_id doc_single
    ad_hash[:internal_color_id] = internal_color_id doc_single

    ad_hash[:location]  = location doc_single
    loc = Geocoder.search (ad_hash[:location])
    ad_hash[:latitude]  = loc[0].try(:latitude)
    ad_hash[:longitude] = loc[0].try(:longitude)

    ad_hash[:year] = year(doc_single)

    feature = doc_single.css('#ctl00_cphMain_SelectedAdInfo1_lblBrandModelYear')
    make_name = feature.text.split("،")[1].strip
    car_model_name = feature.text.split("،")[2].strip

    make = Make.find_or_create_by(name: make_name)
    car_model = CarModel.find_by(name: car_model_name)
    unless car_model
    	car_model = CarModel.create(name: car_model_name, make_id: make.id)
    end

    ad_hash[:car_model_id] = car_model.id

    # ad_hash[:car_model] = car_model(doc_single)
    # ad_hash[:car_model = feature.text.split("،")[1]
    # brand = feature.text.split("،")[2]

		ad_hash[:usage_type] = usage_type(ad_hash[:price], ad_hash[:millage])

		check_for_being_ads_new(doc_single)
    
    ad_hash
  end

  def tel doc_single
		doc_single.css('#ctl00_cphMain_SelectedAdInfo1_lblCellphoneNumber').text
  end

  def price doc_single
    price = doc_single.css('#ctl00_cphMain_SelectedAdInfo1_lblPrice')
    (price.text.gsub! ",", "").to_i
  end

  def millage doc_single
    millage = doc_single.css('#ctl00_cphMain_SelectedAdInfo1_lblMilage')
    millage.text.to_i
  end

  def details doc_single
  	doc_single.css('#ctl00_cphMain_SelectedAdInfo1_lblDescr').text
  end

  def girbox doc_single
    girbox_type = doc_single.css('#ctl00_cphMain_SelectedAdInfo1_lblGearboxType')
    GIRBOX_ARR.index girbox_type.text
  end

  def fuel doc_single
    fuel = doc_single.css('#ctl00_cphMain_SelectedAdInfo1_lblFuelType')
    FUEL_ARR.index fuel.text
  end

  def internal_color_id doc_single
    internal_color_id = doc_single.css('#ctl00_cphMain_SelectedAdInfo1_lblInColor')
    COLORS.index internal_color_id.text
  end

  def body_color_id doc_single
    body_color_id = doc_single.css('#ctl00_cphMain_SelectedAdInfo1_lblExColor')
    COLORS.index body_color_id.text
  end

  def location doc_single
    doc_single.css('#ctl00_cphMain_SelectedAdInfo1_lblProvinceName').text
  end

  def year doc_single
    feature = doc_single.css('#ctl00_cphMain_SelectedAdInfo1_lblBrandModelYear')
    year = feature.text.split("،")[0].to_i
    if year < 1900
      JalaliDate.new(year,10,15).to_g
    else
      ("#{year}-1-1").to_date
    end
  end

  def check_for_being_ads_new doc_single
    date = doc_single.css('#ctl00_cphMain_SelectedAdInfo1_lblDate')
      if date != "امروز"
      	self.count = self.count + 1
      else
      	self.count = 0
      end
  end

  def usage_type price, millage
    if price == 0 && millage == 0
      2
    elsif millage == 0
      1
    else
      0
    end  	
  end

end
