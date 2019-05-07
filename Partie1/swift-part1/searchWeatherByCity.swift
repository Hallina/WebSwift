//
//  searchWeatherByCity.swift
//  swift-part1
//
//  Created by m2sar on 05/04/2019.
//  Copyright © 2019 m2sar. All rights reserved.
//
import Cocoa
import Foundation

//Drizzle, Rain, Clear, Clouds, Thunderstorm, Snow, Atmosphere : { Mist, Smoke, Haze, Dust, Fog, Sand, Ash, Squall, Tornado }
//https://openweathermap.org/weather-conditions

struct City : Codable{
    let id : Int
    let name : String
    let country: String
}

struct Main : Codable {
    let temp : Float
    let pressure : Float
    let humidity : Float
    let temp_min : Float
    let temp_max : Float
    let sea_level : Float
    let ground_level : Float
}

struct Wind : Codable{
    let speed : Float
    let degree : Float
}

struct Clouds : Codable{
    let all : Float
}

struct Rain : Codable{
    let one_hour : Int
    let three_hour : Int
}

struct Snow : Codable{
    let one_hour : Int
    let three_hour : Int
}

struct Weather : Codable{
    
    enum possibleWeather : String, Codable{
        case Drizzle, Rain, Clear, Clouds, Thunderstorm, Snow, Mist, Smoke, Haze, Dust, Fog, Sand, Ash, Squall, Tornado
    }
    
    let main: possibleWeather
    let description: String
}

struct CityWeather : Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind?
    let rain: Rain?
    let clouds: Clouds?
    let snow: Snow?
    let dt: Int
    let name : String
}

//several city searches or a search of the weather for 5 days
//not implement
struct MultipleCityWeather: Codable {
    let list: [CityWeather]
    let city: City
}

private let openWeatherMapAPIKey = "9e6d39413722f1a451125d937bf8b5b9"

func getWeather(city: String) {
    let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&APPID=\(openWeatherMapAPIKey)")!
    print (url)
    
    // The data task retrieves the data.
    //ne passe jamais ici
    let task = URLSession.shared.dataTask(with: url) { (data,
        response, error) in
        let jsonDecoder = JSONDecoder()
        if let error = error {
            // Case 1: Error
            // We got some kind of error while trying to get data from the server.
            print("Error:\n\(error)")
        }
        if let data = data,
            let report = try? jsonDecoder.decode(CityWeather.self, from: data) {
        }
    }
    
    // The data task is set up...launch it!
    task.resume()
}




