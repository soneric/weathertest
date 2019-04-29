//
//  openWeatherRepositorie.swift
//  weatherTest
//
//  Created by Eric Soares Filho on 25/04/19.
//  Copyright © 2019 ERIMIA. All rights reserved.
//

import Foundation
import UIKit

class openWeatherRepositories {
    
    enum APPError: Error {
        case networkError(Error)
        case dataNotFound
        case jsonParsingError(Error)
        case invalidStatusCode(Int)
    }
    
    enum Result<WeatherModel> {
        case success(WeatherModel)
        case failureError(APPError)
    }
    
    func getFromDistLatAndLong(lat: Double, lon: Double, isCelsius: Bool, completion: @escaping (openWeatherRepositories.Result<WeatherModel>) -> Void) {
        var temp = "metric"
        
        if isCelsius == false {
            temp = "imperial"
        }
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/find?lat=\(lat)&lon=\(lon)&cnt=50&appid=ecadce7c25c63a492c7b6b98b3032ee9&units=\(temp)&lang=pt") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    //completion(Result.failureError(APPError.networkError(error as! DecodingError)))
                    print("erro de conexão")
                    return
            }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: []) as AnyObject
                let weather = self.convertJSONtoWeather(json: jsonResponse )
                completion(Result.success(weather!))
            } catch let error {
                completion(Result.failureError(APPError.jsonParsingError(error as! DecodingError)))
            }
        }
        task.resume()
    }
    
    
    func convertJSONtoWeather(json: AnyObject) -> WeatherModel? {
        var weatherReturn = WeatherModel()
        
        if let message = json["message"] as? String {
            weatherReturn.message = message
        }
        
        if let cod = json["cod"] as? String {
            weatherReturn.cod = cod
        }
        
        if let count = json["count"] as? Int {
            weatherReturn.count = count
        }
        
        if let list = json["list"] as? [AnyObject] {
            weatherReturn.list = [List]()
            for jsonAux in list {
                var listAux = List()
                if let id = jsonAux["id"] as? Int {
                    listAux.id = id
                }
                
                if let name = jsonAux["name"] as? String {
                    listAux.name = name
                }
                
                if let coord = jsonAux["coord"] as? AnyObject {
                    listAux.coord = Coord()
                  
                    if let lat = coord["lat"] as? Double {
                        listAux.coord?.lat = lat
                    }
                    
                    if let lon = coord["lon"] as? Double {
                        listAux.coord?.lon = lon
                    }
                }
                
                if let main = jsonAux["main"] as? AnyObject{
                    listAux.main = Main()
                    
                    if let temp = main["temp"] as? Double {
                        listAux.main?.temp = temp
                    }
                    
                    if let pressure = main["pressure"] as? Double {
                        listAux.main?.pressure = pressure
                    }
                    
                    if let humidity = main["humidity"] as? Double {
                        listAux.main?.humidity = humidity
                    }
                    
                    if let temp_min = main["temp_min"] as? Double {
                        listAux.main?.temp_min = temp_min
                    }
                    
                    if let temp_max = main["temp_max"] as? Double {
                        listAux.main?.temp_max = temp_max
                    }
                    
                    if let sea_level = main["sea_level"] as? Double {
                        listAux.main?.sea_level = sea_level
                    }
                    
                    if let grnd_level = main["grnd_level"] as? Double {
                        listAux.main?.grnd_level = grnd_level
                    }
                }
                
                if let dt = jsonAux["dt"] as? Int {
                    listAux.dt = dt
                }
                
                if let wind = jsonAux["wind"] as? AnyObject {
                    listAux.wind = Wind()
                    
                    if let speed = wind["speed"] as? Double {
                        listAux.wind?.speed = speed
                    }
                    
                    if let deg = wind["deg"] as? Double {
                        listAux.wind?.deg = deg
                    }
                }
                
                if let sys = jsonAux["sys"] as? AnyObject {
                    listAux.sys = Sys()
                    
                    if let country = sys["country"] as? String {
                        listAux.sys?.country = country
                    }
                }
                
                if let clouds = jsonAux["clouds"] as? AnyObject {
                    listAux.clouds = Clouds()
                    
                    if let all = clouds["all"] as? Int {
                        listAux.clouds?.all = all
                    }
                }
                
                if let weather = jsonAux["weather"] as? [AnyObject] {
                    listAux.weather = [Weather]()
                    for weatherAux in weather {
                        var weatherResult = Weather()
                        if let id = weatherAux["id"] as? Int {
                            weatherResult.id = id
                        }
                        
                        if let main = weatherAux["main"] as? String {
                            weatherResult.main = main
                        }
                        
                        if let description = weatherAux["description"] as? String {
                            weatherResult.description = description
                        }
                        
                        if let icon = weatherAux["icon"] as? String {
                            weatherResult.icon = icon
                            
                            if let url = URL(string: "https://openweathermap.org/img/w/" + icon + ".png"){
                                    let data = try? Data(contentsOf: url)
                                weatherResult.iconImage = UIImage(data: data!)
                            }else {
                                print("imagem nao encontrada")
                            }
                        }
                        
                        listAux.weather?.append(weatherResult)
                    }
                }
                
                weatherReturn.list?.append(listAux)
            }
        }
        
        return weatherReturn
    }
    
    
}
