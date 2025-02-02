//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Rosh on 31/01/25.
//

import Foundation


struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
}
