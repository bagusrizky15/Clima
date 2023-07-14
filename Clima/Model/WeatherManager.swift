//
//  WeatherManager.swift
//  Clima
//
//  Created by bagus on 13/07/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=94348e922ca54f11ed1b2f434777a516&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName:String){
        let urlString = "\(url)&q=\(cityName)"
        performReq(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(url)&lat=\(latitude)&lon=\(longitude)"
        performReq(with: urlString)
    }
    
    func performReq(with urlString: String){
        
        //create url
        if let url = URL(string: urlString){
            
            //create url session
            let session = URLSession(configuration: .default)
            
            //give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let cWeather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: cWeather)
                    }
                }
            }
            
            //start the task
            task.resume()
            
        }
    }
    
    func parseJSON(_ weatherData : Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temp: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
