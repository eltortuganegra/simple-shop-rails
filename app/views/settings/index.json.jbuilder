json.array!(@settings) do |setting|
  json.extract! setting, :id, :confirmation_code
  json.url setting_url(setting, format: :json)
end
