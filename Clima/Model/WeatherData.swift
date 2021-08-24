//
//  WeatherData.swift
//  Clima
//
//  Created by Abdulrahman Elsharqawi on 18/08/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let list: [List]
}

struct List: Codable {
    let main: Main
    let name: String
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Float
}

struct Weather: Codable {
    let id: Int
}
