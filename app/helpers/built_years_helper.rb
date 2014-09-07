module BuiltYearsHelper

  def built_year_title built_year
    title = " "
    title = title + built_year.car_model.make.name + "، "
    title = title + built_year.car_model.name    + "، "
    title = title + built_year.year.to_s
  end

end
