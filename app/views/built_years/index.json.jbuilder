json.array!(@built_years) do |built_year|
  json.extract! built_year, :id, :year, :gearbox, :engine_displacement
  json.url built_year_url(built_year, format: :json)
end
