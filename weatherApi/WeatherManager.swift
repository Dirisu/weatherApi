//
//  WeatherApi.swift
//  weatherApi
//
//  Created by Marvellous Dirisu on 03/08/2022.
//

import Foundation


struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=c6f5f25b43865f01a2def46ad15a38be&units=metric"
    
    func fetchWeather(cityName : String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
    }
}
