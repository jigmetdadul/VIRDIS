//
//  MainController.swift
//  viridis_beta2
//
//  Created by Jigmet stanzin Dadul on 16/04/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class MainController: UIViewController{
    
    
    @IBOutlet weak var CarbonFootprintProgress: UIProgressView!
    
    
    
    var carbonMan = CarbonFootPrintManager()
    var finalOffset:Float = 0.0
    var UserCarType = ""
    var UserDistanceTravel:Float = 0.0
    var UserFlightType = ""
    var UserFlightDistance:Float = 0.0
    let db = Firestore.firestore()
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var carbonOffsetField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.secondView.layer.cornerRadius = 10
        carbonMan.delegate = self
        loadUserData()

}
    
    @IBAction func info(_ sender: UIButton) {
        if let url = URL(string: "https://www.nature.org/en-us/get-involved/how-to-help/carbon-footprint-calculator/") {
                         UIApplication.shared.open(url)
                      }
        print("pressed")
    }
    
    
    func returnDivisor(n: Int)->Int{

       var count = 0
       var num = n
       if (num == 0){
          return 1
       }
     
       while (num > 0){
          num = num / 10
          count += 1
       }

        var mul = 1
        if count == 1{
            return mul
        }
        mul = 10
        while(count>1){
            mul = mul*10
            count -= 1
        }
        return mul
    }
    
    
    
    func loadUserData(){
        if let currentUserEmail = Auth.auth().currentUser?.email{
            let docRef = db.collection("UserCarbonData").document(currentUserEmail)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let dataDescription = document.data(){
                        print("Get Document data: \(dataDescription)")
                        self.UserCarType = dataDescription["CarType"] as! String
                        self.UserFlightType = dataDescription["FlightType"] as! String
                        self.UserDistanceTravel = dataDescription["Distance"] as! Float
                        self.UserFlightDistance = dataDescription["FlightDistance"] as! Float
                        self.carbonMan.fetchFlightOffset(userDistance: self.UserDistanceTravel, userVehicle: self.UserCarType)
                        self.carbonMan.fetchCarOffset(userFlight: self.UserFlightType, userDistance: self.UserFlightDistance)
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
}

//MARK: - CarbonFootprintManagerDelegate

extension MainController: CarbonFootprintManagerDelegate{
    func didFetchedOffset(totalOffset: Float) {
        finalOffset += totalOffset
        //need to fix the progress value offset
        DispatchQueue.main.async {
            let divisor = self.returnDivisor(n: Int(self.finalOffset))
            self.carbonOffsetField.text = String(format: "%.2f kg co2", self.finalOffset)
            //self.CarbonFootprintProgress.progress = self.finalOffset/Float(divisor)
            print(self.finalOffset/Float(divisor))
            print(self.finalOffset)
            print(divisor)
        }
        print("finalOffset in main Controller: \(finalOffset)")
    }
    
    func didFailWithError(error: Error) {
        print("Failed with error\(error.localizedDescription)")
    }
    
}
