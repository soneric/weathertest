//
//  WeatherModel.swift
//  weatherTest
//
//  Created by entelgy on 26/04/19.
//  Copyright © 2019 ERIMIA. All rights reserved.
//

import Foundation

struct WeatherModel {
    var message: String?
    var cod: String?
    var count: Int?
    var list: [List]?
}

struct List {
    var id: Int?
    var name: String?
    var coord: Coord?
    var main: Main?
    var dt: Int?
    var wind: Wind?
    var sys: Sys?
    var clouds: Clouds?
    var weather: [Weather]?
}

struct Coord{
    var lat: Double?
    var lon: Double?
    var dist: Double?
}

struct Main {
    var temp: Double?
    var pressure: Double?
    var humidity: Double?
    var temp_min: Double?
    var temp_max: Double?
    var sea_level: Double?
    var grnd_level: Double?
}

struct Wind {
    var speed: Double?
    var deg: Double?
}

struct Sys {
    var country: String?
}

struct Clouds {
    var all: Int?
}

struct Weather {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}
