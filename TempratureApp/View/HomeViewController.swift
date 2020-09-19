//
//  ViewController.swift
//  TempratureApp
//
//  Created by Asad Choudhary on 9/19/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelOutsideTempInfo: UILabel!
    @IBOutlet weak var labelInsideTempInfo: UILabel!
    @IBOutlet weak var labelTempDiff: UILabel!
    
    var dataSource: GenericDataSource<TemperatureDataModel>?
    lazy var viewModel : HomeViewModel = {
        let viewModel = HomeViewModel(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializations()
    }
    
    func initializations() {
        dataSource = GenericDataSource()
        addObservers()
        initializeErrorHandler()
        loadContent()
    }
    
    func addObservers() {
        // add observers to listen when new data available
        self.dataSource?.data.addObserver(self) { [weak self] _ in
            // Callback from ViewModel when it receives data

            self?.loadingIndicator.stopAnimating()
            if let currentTemp = self?.dataSource?.data.value[0] {
                // Populate Outside Temperature
                self?.labelOutsideTempInfo.text = "Temperature: \(currentTemp.temp) \u{00B0}C\nPressure: \(currentTemp.pressure) hPa\nHumidity: \(currentTemp.humidity) %";
                // Populate Inside Temperature
                if let (insideTemp, insidePressure, insideHumidity) = self?.viewModel.getInsideTemperatureInfo() {
                    self?.labelInsideTempInfo.text = "Temperature: \(insideTemp) \u{00B0}C\nPressure: \(insidePressure) hPa\nHumidity: \(insideHumidity) %";
                    self?.labelTempDiff.text = "AC is able to change \(Int(self!.viewModel.calculteTempDiffPercent(insideTemp: insideTemp, outsideTemp: currentTemp.temp)))% of Temperature"
                }
            }
            
        }
    }
    
    func initializeErrorHandler() {
        // add error handling example
        self.viewModel.onErrorHandling = { [weak self] error in
            
            self?.loadingIndicator.stopAnimating()
            let controller = UIAlertController(title: NSLocalizedString("anErrorOccured", comment: ""), message: error?.localizedDescription, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
            self?.present(controller, animated: true, completion: nil)
        }
    }

    func loadContent() {
        self.viewModel.fetchCurrentLocation()
        self.viewModel.findBeacon()
    }

}

