# frozen_string_literal: true

require 'net/http'
require 'json'

module Package
  class Builder
    def self.cargo_information(hash)
      raise 'Space is not a value' if hash.value?('')

      distance = distance(hash[:origins], hash[:destinations])
      price = price(hash, distance)
      hash.merge!({ distance: distance, price: price })
    end

    def self.routs(origins, destinations)
      raise "You can't enter two identical values" if origins == destinations

      uri = URI("https://api.mapbox.com/geocoding/v5/mapbox.places/#{origins.strip.sub(/[" "]/, '%20')}%2C#{destinations.strip.sub(/[" "]/, '%20')}.json?country=ru&limit=2&proximity=ip&types=place&access_token=#{ENV['TOKEN_MAPBOX']}")
      res = Net::HTTP.get_response(uri)
      res.body if res.is_a?(Net::HTTPSuccess)
    end

    def self.distance(origins, destinations)
      response = routs(origins, destinations)
      parse_response = JSON.parse(response, symbolize_names: true)
      orig = parse_response[:features][0][:center]
      dest = parse_response[:features][1][:center]
      distance_length(orig, dest)
    end

    def self.distance_length(orig, dest)
      uri = URI("https://api.mapbox.com/directions/v5/mapbox/driving/#{orig[0]},#{orig[1]}%3B#{dest[0]},#{dest[1]}?alternatives=true&geometries=geojson&overview=simplified&steps=false&access_token=#{ENV['TOKEN_MAPBOX']}")
      res = Net::HTTP.get_response(uri)
      response = res.body if res.is_a?(Net::HTTPSuccess)
      parse_response = JSON.parse(response, symbolize_names: true)
      ((parse_response[:routes][0][:distance]) / 1000.0).round(1)
    end

    def self.price(hash, distance)
      if hash[:weight].to_f <= 0 || hash[:length].to_i <= 0 || hash[:width].to_i <= 0 || hash[:height].to_i <= 0
        raise 'Values cannot be negative'
      end

      cargo_size = (hash[:length].to_i * hash[:width].to_i * hash[:height].to_i) / 100
      if cargo_size <= 0.01
        distance.round
      elsif cargo_size > 0.01 && hash[:weight].to_f <= 10
        (distance * 2).round
      else
        cargo_size > 0.01 && hash[:weight].to_f > 10
        (distance * 3).round
      end
    end
    private_class_method :routs, :distance, :distance_length, :price
  end
end
