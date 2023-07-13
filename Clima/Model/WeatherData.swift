//
//  WeatherData.swift
//  Clima
//
//  Created by bagus on 13/07/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData : Codable {
    let name:String
    let weather:[Weather]
    let main:Main
}

struct Weather: Codable {
    let id : Int
}

struct Main: Codable {
    let temp : Double
}
