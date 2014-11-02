json.array!(@points) do |point|
  json.extract! point, :id, :temperature, :pm25, :group, :created_at
  json.url point_url(point, format: :json)
end
