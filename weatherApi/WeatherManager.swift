//
//  WeatherApi.swift
//  weatherApi
//
//  Created by Marvellous Dirisu on 03/08/2022.
//

import Foundation

// set the weather manager protocol to make it reusable at different points/classes

protocol weatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error : Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=c6f5f25b43865f01a2def46ad15a38be&units=metric"
    
    // weather manager delegate
    var delegate: weatherManagerDelegate?
    
    func fetchWeather(cityName : String) {
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    
                    self.delegate?.didFailWithError(error: error!)
                    
                    return
                }
                
                if let safeData = data {
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print(dataString)
                    
                    // parse data in JSON format and return weatherData
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
            print(weather.conditionName)
            print(weather.temperatureString)
            
//            print(decodedData.name)
//            print(decodedData.main.temp)
//            print(decodedData.weather[0].description)
//            print(decodedData.weather[0].id)
            
        } catch {
            delegate?.didFailWithError(error: error)
            // returns nil if data is not parsed
            return nil
        }
    }
    
}
