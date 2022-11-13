class WeatherApi
  def self.weather_in(city)
    city = city.downcase
    Rails.cache.fetch("#{city}_weather", expires_in: 1.hours) { get_weather_in(city) }
  end

  def self.get_weather_in(city)
    query = {
      "access_key" => key,
      "query" => ERB::Util.url_encode(city)
    }
    url = "http://api.weatherstack.com/current"
    response = HTTParty.get url, query: query

    return [] if response.is_a?(Hash) && (weather.nil? || response.body.empty?)

    weather = JSON.parse(response.to_json, object_class: Weather)
    weather.current
  end

  def self.key
    return nil if Rails.env.test? # testatessa ei apia tarvita, palautetaan nil
    raise 'WEATHER_APIKEY env variable not defined' if ENV['WEATHER_APIKEY'].nil?

    ENV.fetch('WEATHER_APIKEY')
  end
end
