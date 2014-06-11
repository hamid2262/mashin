json.array!(@articles) do |article|
  json.extract! article, :id, :title, :topic_id_id, :thumb, :truncate, :url
  json.url article_url(article, format: :json)
end
