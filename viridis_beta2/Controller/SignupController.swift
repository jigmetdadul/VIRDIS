//
//  SignupController.swift
//  viridis_beta2
//
//  Created by Jigmet stanzin Dadul on 16/04/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SignupController: UIViewController {

    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func SignUpButtonPressed(_ sender: UIButton) {
        if let email = EmailField.text, let password = PasswordField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if let e = error{
                    print("Error while signing up:\(e.localizedDescription)")
                }
                else{
                    print("Sign Up successfull")
                    self.performSegue(withIdentifier: "newUserDataSegue", sender: self)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
