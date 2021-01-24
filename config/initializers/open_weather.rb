OpenWeather::Client.configure do |config|
    config.api_key = Rails.application.credentials.open_weather[:token]
    config.user_agent = Rails.application.credentials.open_weather[:user_agent]
end