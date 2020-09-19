//
//  HomeViewModel.swift
//  TempratureApp
//
//  Created by Asad Choudhary on 9/19/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import UIKit
import MKBeaconXProSDK
import CoreLocation


class HomeViewModel: NSObject {
    
    weak var dataSource : GenericDataSource<TemperatureDataModel>?
    weak var service: OpenWeatherServiceProtocol?
    var onErrorHandling : ((ErrorResult?) -> Void)?
    
    let locationManager = CLLocationManager()

    init(dataSource : GenericDataSource<TemperatureDataModel>?) {
        self.dataSource = dataSource
        self.service = OpenWeatherService.shared
    }
    
    func fetchOutsideTemperature(lat: Double, lon: Double) {
        guard let service = service else {
            onErrorHandling?(ErrorResult.custom(string: ""))
            return
        }
        
        service.fetchTemperature(lat: lat, lon: lon) { (result) in
            switch result {
                case .success(let data) :
                    self.dataSource?.data.value.append(data)
                case .failure(let error) :
                    self.onErrorHandling?(error)
                }
        }
    }
    
    func findBeacon() {
        
        let beacon = MKBXPTLMBeacon()

        let manager = MKBXPCentralManager()
        
        
        
        manager.connectPeripheral(beacon.peripheral, progressBlock: { (f) in
            print("Beacon progress")
        }, sucBlock: { (perf) in
            print("Beacon success")
            
            print("device name: \(beacon.deviceName)")
            print("temperature: \(beacon.temperature)")
        }) { (error) in
            print("Beacon error: \(error)")
            
        }
        
    }
    
    func getInsideTemperatureInfo() -> (Double, Double, Double){
        return (25.0, 900, 30)
    }
    
    func calculteTempDiffPercent(insideTemp: Double, outsideTemp: Double) -> Double {
        return ((insideTemp / outsideTemp) * 100);
    }
}

extension HomeViewModel: CLLocationManagerDelegate {

    func fetchCurrentLocation() {
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        // Get Data through API after getting current location
        self.fetchOutsideTemperature(lat: Double(locValue.latitude), lon: Double(locValue.longitude))
        self.locationManager.stopUpdatingLocation()
    }
    
    
}
