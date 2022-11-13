class WeatherApi
  def self.weather_in(city)
    city = city.downcase
    Rails.cache.fetch("#{city}_weather", expires_in: 1.hours) { get_weather_in(city) }
  end

  def self.get_weather_in(city)
    url = "http://api.weatherstack.com/current?access_key=#{key}&query=#{city}"
    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"

    return [] if response.is_a?(Hash) && (weather.nil? || response.body.empty?)

    JSON.parse(response.to_json, object_class: OpenStruct).current
  end

  def self.key
    return nil if Rails.env.test? # testatessa ei apia tarvita, palautetaan nil
    raise 'WEATHER_APIKEY env variable not defined' if ENV['WEATHER_APIKEY'].nil?

    ENV.fetch('WEATHER_APIKEY')
  end
end
