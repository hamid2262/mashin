crumb :root do
  link "خانه", root_url, title: "اتویابی - سایت خرید و فروش خودرو"
end

crumb :make do |make|
  link make.name, make_url(make), title: "فروش خودرو #{make.name}"
  parent :root
end

crumb :car_model do |car_model|
  link car_model.name, make_car_model_url(id: car_model.id, make_id: car_model.make.slug), title: "فروش خودرو #{car_model.make.name} #{car_model.name} "
  parent :make, car_model.make
end

crumb :built_year do |built_year|
  link built_year.year, make_car_model_built_year_url(id: built_year.year, make_id: built_year.car_model.make.slug, car_model_id: built_year.car_model.id), title: "فروش خودرو #{built_year.car_model.make.name} #{built_year.car_model.name} سال #{built_year.year}"
  parent :car_model, built_year.car_model
end

crumb :ad do |ad|
  link "مشخصات خودرو", ad_path
  parent :built_year, ad.built_year
end