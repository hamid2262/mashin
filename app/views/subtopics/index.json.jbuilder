json.array!(@subtopics) do |subtopic|
  json.extract! subtopic, :id, :topic_id, :name, :slug
  json.url subtopic_url(subtopic, format: :json)
end
