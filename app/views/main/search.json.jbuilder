json.users do
  json.array!(@users) do |user|
    json.name user.username
    json.url user_path(user)
  end
end
