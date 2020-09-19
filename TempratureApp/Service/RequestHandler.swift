//
//  RequestHandler.swift
//  TempratureApp
//
//  Created by Asad Choudhary on 9/19/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import UIKit
import Alamofire

class RequestHandler {
    
    var request: DataRequest?
    
    func networkRequest(endPoint: String, ticks: String? = nil, _ completion: @escaping ((Result<[String: Any], ErrorResult>) -> Void)) {
        var parameters: [String: Any] = [:]
        if let ticks = ticks {
            parameters["Ticks"] = ticks
        }
        
        request = AF.request(endPoint, parameters: parameters).responseJSON { response in
            
            switch response.result {
            case .success:
                do {
                    if let json = try JSONSerialization.jsonObject(with: response.data!, options: [])  as? [String:Any] {
                        completion(.success(json))
                    }
                    else
                    {
                        completion(.failure(.parser(string: NSLocalizedString("unableToParse", comment: ""))))
                    }
                } catch _ as NSError {
                    completion(.failure(.parser(string: NSLocalizedString("unableToParse", comment: ""))))
                }
                break
            case .failure(let error):
                print(error)
                completion(.failure(.network(string: NSLocalizedString("networkError", comment: ""))))
                break
            }
            
        }
    }
    
    func cancelNetworkRequest() {
        request?.cancel()
    }
    
}
