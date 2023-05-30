//
//  FlightTravelController.swift
//  viridis_beta2
//
//  Created by Jigmet stanzin Dadul on 20/04/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class FlightTravelController: UIViewController {

    
    @IBOutlet weak var FlightTypePicker: UIPickerView!
    @IBOutlet weak var InteractionView: UIView!
    @IBOutlet weak var DistanceField: UITextField!
    let FlightTravelValue = ["DomesticFlight", "ShortEconomyClassFlight", "ShortBusinessClassFlight", "LongEconomyClassFlight", "LongPremiumClassFlight", "LongBusinessClassFlight", "LongFirstClassFlight"]
    var userFlightType = ""
    var userDistanceTraveled:Float = -1
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InteractionView.layer.cornerRadius = 20
        FlightTypePicker.dataSource = self
        FlightTypePicker.delegate = self
        DistanceField.delegate = self
        userFlightType = FlightTravelValue[0]

        // Do any additional setup after loading the view.
    }
    func uploadCarData(){
        if let emailCurrent = Auth.auth().currentUser?.email{
            db.collection("UserCarbonData").document(emailCurrent).setData([ "FlightType": userFlightType, "FlightDistance": userDistanceTraveled ], merge: true)
        }
    }
}
extension FlightTravelController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            DistanceField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            if Float(textField.text!) ?? -01.01 >= 0 {
                return true
            }else{
                DistanceField.text = ""
                DistanceField.placeholder = "Enter a positive Value"
                return false
            }
        }else{
            DistanceField.text = ""
            DistanceField.placeholder = "Enter a numeric Value"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let distance = textField.text{
            userDistanceTraveled = Float(distance) ?? 01.01
            print(userDistanceTraveled)
            uploadCarData()
            performSegue(withIdentifier: "SignupIdentifier", sender: self)
        }else{
            print("error while ending text field")
        }
    }
    
}

extension FlightTravelController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return FlightTravelValue.count
    }
}

extension FlightTravelController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return FlightTravelValue[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        userFlightType = FlightTravelValue[row]
        print(userFlightType)
    }
}

