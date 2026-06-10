//
//  WeatherViewModel.swift
//  SwiftyWeather
//
//  Created by Oscar De Villiers on 2026/06/04.
//

import Foundation

@Observable
class WeatherViewModel {
    
    private struct Returned: Codable {
        var current: Current
        var daily: Daily
    }
    
    struct Current: Codable {
        var temperature_2m: Double
        var apparent_temperature: Double
        var weather_code: Int
        var wind_speed_10m: Double
    }
    
    struct Daily: Codable {
        var time: [String] = []
        var weather_code: [Int] = []
        var temperature_2m_max: [Double] = []
        var temperature_2m_min: [Double] = []
    }
    
    var urlString = "https://api.open-meteo.com/v1/forecast?latitude=42.33467401570891&longitude=-71.17007347605109&daily=uv_index_max,weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m&timezone=auto&wind_speed_unit=mph&temperature_unit=fahrenheit&precipitation_unit=inch"
    
    var temperature = 0.0
    var feelsLike = 0.0
    var windspeed = 0.0
    var weather_code = 0
    var date: [String] = []
    var dailyWeatherCode: [Int] = []
    var dailyHighTemp: [Double] = []
    var dailyLowTemp: [Double] = []
    
    func getData() async {
        print("🕸️We are accessing the url: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("😡ERROR: Could not create url from \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // Try to decode JSON into our own data structure
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON ERROR: Could not decode returned JSON from data.")
                return
            }
            self.temperature = returned.current.temperature_2m
            self.feelsLike = returned.current.apparent_temperature
            self.windspeed = returned.current.wind_speed_10m
            self.weather_code = returned.current.weather_code
            self.date = returned.daily.time
            self.dailyWeatherCode = returned.daily.weather_code
            self.dailyHighTemp = returned.daily.temperature_2m_max
            self.dailyLowTemp = returned.daily.temperature_2m_min
        } catch {
            print("😡JSON ERROR: Could not get datae from \(urlString)")
        }
    }
    
    
}
