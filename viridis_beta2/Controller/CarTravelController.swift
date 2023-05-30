//
//  CaTravelDataController.swift
//  viridis_beta2
//
//  Created by Jigmet stanzin Dadul on 20/04/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CarTravelController: UIViewController {

    
    @IBOutlet weak var CarTypePicker: UIPickerView!
    @IBOutlet weak var InteractionView: UIView!
    
    let db = Firestore.firestore()

    @IBOutlet weak var DistanceField: UITextField!
    let CarTypePickerValue = ["MediumDieselCar", "LargeDieselCar", "MediumHybridCar", "LargeHybridCar", "MediumLPGCar", "LargeLPGCar", "MediumCNGCar", "LargeCNGCar", "SmallPetrolVan", "LargePetrolVan", "SmallDielselVan", "MediumDielselVan", "LargeDielselVan", "LPGVan", "CNGVan", "SmallPetrolCar", "MediumPetrolCar", "LargePetrolCar", "SmallMotorBike", "MediumMotorBike", "LargeMotorBike"]
    var userCarType = ""
    var userDistanceTraveled:Float = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InteractionView.layer.cornerRadius = 20
        CarTypePicker.dataSource = self
        CarTypePicker.delegate = self
        DistanceField.delegate = self
        userCarType = CarTypePickerValue[0]// Default value for user car type
    }
    
    func uploadCarData(){
        if let emailCurrent = Auth.auth().currentUser?.email{
            db.collection("UserCarbonData").document(emailCurrent).setData([
                "CarType": userCarType,
                "Distance": userDistanceTraveled,
            ]) { err in
                if let err = err {
                    print("Error writing document in car travel: \(err)")
                } else {
                    print("Document in car travel successfully written!")
                }
            }
        }
    }
}


//MARK: TEXTFIELDDELEGATE

extension CarTravelController: UITextFieldDelegate{
    
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
            performSegue(withIdentifier: "newUserDataSegue2", sender: self)
        }else{
            print("error while ending text field")
        }
    }
}
//MARK: UIPICKERVIEWDElEGATE
extension CarTravelController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CarTypePickerValue.count
    }
}

extension CarTravelController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return CarTypePickerValue[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        userCarType = CarTypePickerValue[row]
        print("User car type selected:\(userCarType)")
    }
}


