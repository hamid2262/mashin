json.array!(@topics) do |topic|
  json.extract! topic, :id, :name, :subdomain
  json.url topic_url(topic, format: :json)
end
