//
//  OpenWeatherService.swift
//  TempratureApp
//
//  Created by Asad Choudhary on 9/19/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import Foundation

protocol OpenWeatherServiceProtocol : class {
    func fetchTemperature(lat: Double, lon: Double, _ completion: @escaping ((Result<TemperatureDataModel, ErrorResult>) -> Void))
}

final class OpenWeatherService : RequestHandler, OpenWeatherServiceProtocol {
    
    let endpoint = "https://api.openweathermap.org/data/2.5/onecall?units=metric&appid=d2c594552c6052ee237a2a7f96075efc"
    static var shared = OpenWeatherService()
    var lastTicks: String?
    
    var task : URLSessionTask?
    
    func fetchTemperature(lat: Double, lon: Double, _ completion: @escaping ((Result<TemperatureDataModel, ErrorResult>) -> Void)) {
        
        networkRequest(endPoint: endpoint + "&lat=\(lat)&lon=\(lon)", ticks: lastTicks) { (result) in
            switch result {
            case .success(let response):
                if let current = response["current"] as? [String: Any] {
                    let currentTemp = TemperatureDataModel.parseObject(dict: current)
                    completion(currentTemp)
                }
                break
                
            case .failure( _):
                completion(.failure(.network(string: NSLocalizedString("networkError", comment: ""))))
                break
            }
        }
    }
    
    func cancelFetchTemperature() {
        cancelNetworkRequest()
    }
    
}
