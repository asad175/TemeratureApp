//
//  TemperatureDataModel.swift
//  TempratureApp
//
//  Created by Asad Choudhary on 9/19/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import UIKit

class TemperatureDataModel {
    var time = Date()
    var temp: Double = 0
    var pressure: Double = 0
    var humidity: Double = 0
    
    init(time: Date, temp: Double, pressure: Double, humidity: Double) {
        self.time = time
        self.temp = temp
        self.pressure = pressure
        self.humidity = humidity
    }
}


extension TemperatureDataModel {

    static func parseObject(dict: [String : Any]) -> Result<TemperatureDataModel, ErrorResult> {
    
        if let dt = dict[TemperatureDataKeys.dt.rawValue] as? Int,
            let temp = dict[TemperatureDataKeys.temp.rawValue] as? Double,
            let humidity = dict[TemperatureDataKeys.humidity.rawValue] as? Double,
            let pressure = dict[TemperatureDataKeys.pressure.rawValue] as? Double {
               
            return Result.success(TemperatureDataModel.init(time: Date(timeIntervalSince1970: TimeInterval(dt)), temp: temp, pressure: pressure, humidity: humidity))
           }
    
     
        return Result.failure(ErrorResult.parser(string: "Unable to parse data"))
    }
    
   
}
