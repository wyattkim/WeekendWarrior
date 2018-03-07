//
//  DataManager.swift
//  
//
//  Created by Alana Kamahele on 3/2/18.
//

import Foundation

import Foundation

enum DataManagerError: Error {
    
    case Unknown
    case FailedRequest
    case InvalidResponse
    
}

final class DataManager {
    
    typealias WeatherDataCompletion = (AnyObject?, DataManagerError?) -> ()
    
    let baseURL: URL
    
    // MARK: - Initialization
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // MARK: - Requesting Data
    func weatherDataForLocation(latitude: Double, longitude: Double, completion: @escaping WeatherDataCompletion) {
        // Create URL
        let URL = baseURL.appendingPathComponent("\(latitude),\(longitude)")
        
        // Create Data Task
        URLSession.shared.dataTask(with: URL) { (data, response, error) in
            self.didFetchWeatherData(data: data, response: response, error: error, completion: completion)
            }.resume()
    }
    
    // MARK: - Helper Methods
    private func didFetchWeatherData(data: Data?, response: URLResponse?, error: Error?, completion: WeatherDataCompletion) {
        if let _ = error {
            completion(nil, .FailedRequest)
            
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                processWeatherData(data: data, completion: completion)
            } else {
                completion(nil, .FailedRequest)
            }
            
        } else {
            completion(nil, .Unknown)
        }
    }
    
    private func processWeatherData(data: Data, completion: WeatherDataCompletion) {
        if let JSON = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject {
            do {
                let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                let currentConditions = parsedData["currently"] as! [String:Any]
                let currentTemperatureF = currentConditions["temperature"] as AnyObject
                let summary = currentConditions["summary"] as AnyObject
                print(currentTemperatureF)
                print(summary)
                completion(currentTemperatureF, nil)
            } catch let error as NSError {
                print(error)
            }
        } else {
            completion(nil, .InvalidResponse)
        }
    }
    
}
