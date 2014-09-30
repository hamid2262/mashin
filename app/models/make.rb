class Make < ActiveRecord::Base
  has_many :car_models
  has_many :ads

  scope :visible, -> { where(visible: true) }
  scope :sorted, -> { order(name: :asc) }
  
  def to_param    
    "#{id}-#{fa_parametrize(self.name)}"
  end

  def self.make_id(name)
    Rails.cache.fetch([:make, name, :id], expires_in: 15.hours) do 
      Make.find_by(name: name).id
    end
  end

  def next
    Make.where("id > ?", self.id).first
  end


  def deligate_obj
    if self.deligate   
      Make.find self.deligate 
    else
      self
    end
  end  

  def ads
    @ads ||= find_ads
  end


  def self.for_menus
    @makes ||= find_makes
  end

  def deligated_car_models
    @car_models ||= find_car_models
  end

  def self.scrap
    url = "http://car-info.herokuapp.com/makes"
    doc = Nokogiri::HTML(open(url))
    get_makes doc
  end

  def popular_car_model_menu
    self.car_models.where('id=deligate').order(:name)
  end

  def car_models_sorted
    makes = self.car_models.where("car_models.id = deligate").joins(:ads).group(['car_models.id'])
    makes.order('COUNT(ads.car_model_id) DESC').count
  end

  private

  def self.get_makes doc
    makes_rows = doc.css 'tr'
    makes_rows.each do |makes_row|
      name = makes_row.at_css(".name").text if makes_row.at_css(".name")
      slug = makes_row.at_css(".slug").text if makes_row.at_css(".slug")
      if slug.present? 
        makes = Make.where name: name
        if makes.present?
          makes.update_all(slug: slug)
        else
          make = Make.create(slug: slug, name: name) 
        end
      end
    end
  end

  def find_ads
    ads = Ad.all.includes(:car_model, car_model: :make)
    ads = ads.order("updated_at DESC") 
    ads = ads.where("status = 2") 
    ads = ads.where( ads:{ make_id: find_make_deligates } )
    ads
  end

  def find_car_models
     self.car_models.where("id = deligate").order(name: :asc) 
  end

  def self.find_makes
    Make.where("id = deligate").order(name: :asc) 
  end

  def find_make_deligates
    make = Make.find id
    Make.where(deligate: make.deligate).ids
  end

  def fa_parametrize val
    val.gsub(' ', '-')  if val
  end

end