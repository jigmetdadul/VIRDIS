//
//  CarbonFootprintManager.swift
//  viridis_beta2
//
//  Created by Jigmet stanzin Dadul on 16/04/23.
//

import Foundation

protocol CarbonFootprintManagerDelegate{
    func didFetchedOffset( totalOffset: Float)
    func didFailWithError(error: Error)
}

struct CarbonFootPrintManager{
    var totalOffset:Double = 0.0
    var delegate: CarbonFootprintManagerDelegate?
    
    let carbonFootprintURL:String = "https://carbonfootprint1.p.rapidapi.com/"
    
    func fetchCarOffset(userFlight:String, userDistance:Float){
        let urlString = "\(carbonFootprintURL)CarbonFootprintFromFlight?distance=\(userDistance)&type=\(userFlight)"
        performRequest(with: urlString, requestType: "Flight")
    }
    
    func fetchFlightOffset(userDistance:Float, userVehicle:String){
        let urlString = "\(carbonFootprintURL)CarbonFootprintFromCarTravel?distance=\(userDistance)&vehicle=\(userVehicle)"
        performRequest(with: urlString, requestType: "Car")
    }
    
    func performRequest(with urlString: String, requestType type: String){
        print("Performing")
        
        let headers = [
            "X-RapidAPI-Key": "your_api_key",
            "X-RapidAPI-Host": "carbonfootprint1.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let e = error {
                self.delegate?.didFailWithError(error: e)
            }
        
            if let safeData = data {
                let httpResponse = response as? HTTPURLResponse
                if let safehttpResponse = httpResponse{
                    if safehttpResponse.statusCode == 200{
                        do{
                            let jsonData = try JSONSerialization.jsonObject(with: safeData)
                            print(type)
                            print(jsonData)
                            let result = jsonData as! Dictionary<String, Double>
                            //Need to fix this
                            let totalOffset:Float = Float(result["carbonEquivalent"]!)
                            self.delegate?.didFetchedOffset(totalOffset: totalOffset)
                            print("The value of carbon eq: \(totalOffset)")
                        }catch{
                            self.delegate?.didFailWithError(error: error)
                            print("Error occured while JSONserialization")
                        }
                    }else{
                        print("Error occured while getting safehttpResponse")
                    }
                }
            }
        })
        
        dataTask.resume()
        
        print("Performed")
    }
}

