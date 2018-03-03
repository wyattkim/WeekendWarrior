//
//  WeatherGetter.swift
//  WeekendWarrior
//
//  Created by Alana Kamahele on 3/2/18.
//  Copyright © 2018 Wyatt Kim. All rights reserved.
//

import Foundation

class WeatherGetter {
    
    func getWeather(city: String) {
        let urlString = URL(string: "http://api.openweathermap.org/data/2.5/forecast?id=524901&APPID={4b282a694f516589ccf2c167a3d8f2e9}")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        print(usableData) //JSONSerialization
                    }
                }
            }
            task.resume()
        }
    }
}

