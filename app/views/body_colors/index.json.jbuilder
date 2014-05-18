json.array!(@body_colors) do |body_color|
  json.extract! body_color, :id, :name, :visible
  json.url body_color_url(body_color, format: :json)
end
