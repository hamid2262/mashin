desc "clear database"
task :cleardb => :environment do
  if Rails.env.development?
    AdOtherField.delete_all
    Ad.delete_all
    CarModel.delete_all
    InternalColor.delete_all
    BodyColor.delete_all
    ImageUrl.delete_all
    Location.delete_all
    Make.delete_all
    Scrap.delete_all
    Search.delete_all
    User.delete_all
  end 
end