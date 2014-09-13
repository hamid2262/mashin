class ScrapCarInfo
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :url
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end

  def scrap
    puts "ScrapCarInfo started"
    @counter = 1
    url = "#{self.url}?page="
    page_num = 1
    while true
      doc = Nokogiri::HTML(open("#{url}#{page_num}"))
      break unless doc.css('.row1').any?
      rows = doc.css('.row1')
      extract_rows(rows) if rows.any?
      page_num = page_num + 1
    end 
  end

  def extract_rows(rows)
    rows.each do |row|
      extract_row(row)
      check_existance_and_save
    end
  end

  def extract_row(row)
    @row_hash = {}
    @row_hash[:make]               = extract_element(row, ".make")
    @row_hash[:car_model]          = extract_element(row, ".car_model")
    @row_hash[:make_farsi]         = extract_element(row, ".make_farsi")
    @row_hash[:car_model_farsi]    = extract_element(row, ".car_model_farsi")
    @row_hash[:year]               = extract_element(row, ".year")
    @row_hash[:gearbox]            = extract_element(row, ".gearbox")
    @row_hash[:diff]               = extract_element(row, ".diff")
    @row_hash[:engine_displacement]= extract_element(row, ".engine_displacement")
    @row_hash[:cylinder]           = extract_element(row, ".cylinder")
    @row_hash[:soupape]            = extract_element(row, ".soupape")
    @row_hash[:power]              = extract_element(row, ".power")
    @row_hash[:torque]             = extract_element(row, ".torque")
    @row_hash[:length]             = extract_element(row, ".length")
    @row_hash[:width]              = extract_element(row, ".width")
    @row_hash[:height]             = extract_element(row, ".height")
    @row_hash[:speed]              = extract_element(row, ".speed")
    @row_hash[:acceleration]       = extract_element(row, ".acceleration")
    @row_hash[:fuel_consumption]   = extract_element(row, ".fuel_consumption")
    @row_hash[:tank_size]          = extract_element(row, ".tank_size")
    @row_hash[:tire]               = extract_element(row, ".tire")
    @row_hash[:emission_standards] = extract_element(row, ".emission_standards")
    @row_hash[:airbag]             = extract_element(row, ".airbag")
    @row_hash[:brake]              = extract_element(row, ".brake")
    @row_hash[:tahvie_hava]        = extract_element(row, ".tahvie_hava")
    @row_hash[:seats]              = extract_element(row, ".seats")
    @row_hash[:shisheha]           = extract_element(row, ".shisheha")
    @row_hash[:ayneha]             = extract_element(row, ".ayneha")
    @row_hash[:cheraghha]          = extract_element(row, ".cheraghha")
    @row_hash[:other_facilities]   = extract_element(row, ".other_facilities")
    @row_hash[:image]              = extract_element(row, ".image")
  end

  def check_existance_and_save
    make = Make.find_or_create_by(name: @row_hash[:make_farsi])
    make.update_attribute(:slug, @row_hash[:make]) # if make.slug.nil?
    make.update_attribute(:deligate, make.id) if make.deligate.nil?

    car_model = CarModel.find_or_create_by(name: @row_hash[:car_model_farsi], make_id: make.id)
    car_model.update_attribute(:slug, @row_hash[:car_model]) # if (car_model and car_model.slug.nil?)
    car_model.update_attribute(:deligate, car_model.id) if car_model.deligate.nil?

    if car_model and make
      built_year = BuiltYear.where(make_id: make.id , car_model_id: car_model.id , year: @row_hash[:year]).first 
      unless built_year
        built_year = BuiltYear.create!(
          :make_id             => make.id,
          :car_model_id        => car_model.id,
          :year                => @row_hash[:year],
          :gearbox             => @row_hash[:gearbox],
          :diff                => @row_hash[:diff],
          :engine_displacement => @row_hash[:engine_displacement],
          :cylinder            => @row_hash[:cylinder],
          :soupape             => @row_hash[:soupape],
          :power               => @row_hash[:power],
          :torque              => @row_hash[:torque],
          :length              => @row_hash[:length],
          :width               => @row_hash[:width],
          :height              => @row_hash[:height],
          :speed               => @row_hash[:speed],
          :acceleration        => @row_hash[:acceleration],
          :fuel_consumption    => @row_hash[:fuel_consumption],
          :tank_size           => @row_hash[:tank_size],
          :tire                => @row_hash[:tire],
          :emission_standards  => @row_hash[:emission_standards],
          :airbag              => @row_hash[:airbag],
          :brake               => @row_hash[:brake],
          :tahvie_hava         => @row_hash[:tahvie_hava],
          :seats               => @row_hash[:seats],
          :shisheha            => @row_hash[:shisheha],
          :ayneha              => @row_hash[:ayneha],
          :cheraghha           => @row_hash[:cheraghha],
          :other_facilities    => @row_hash[:other_facilities],
          :image               => @row_hash[:image]
        ) 
        puts "+++++#{@counter} #{@row_hash[:make]} #{@row_hash[:car_model]} #{@row_hash[:year]}"
      else
        puts "#{@counter} #{@row_hash[:make]} #{@row_hash[:car_model]} #{@row_hash[:year]}"
      end
      @counter = @counter + 1 
    end
  end

  def extract_element (row, element_class)
    row.at_css(element_class).text
  end
end