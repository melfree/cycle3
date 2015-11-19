json.array!(@favorites) do |favorite|
  json.extract! favorite, :id, :user_id, :user_name, :user_email
  json.url favorite_url(favorite, format: :json)
end
