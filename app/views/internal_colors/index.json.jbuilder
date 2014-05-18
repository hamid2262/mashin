json.array!(@internal_colors) do |internal_color|
  json.extract! internal_color, :id, :name, :visible
  json.url internal_color_url(internal_color, format: :json)
end
