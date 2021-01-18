//
//  LoginViewController.swift
//  SlugTracker
//
//  Created by Daniel Carrera on 1/17/21.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailEntry: UITextField!
    
    @IBOutlet weak var passwordEntry: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailEntry.delegate = self
        self.passwordEntry.delegate = self

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginTapped(_ sender: UIButton) {
        // ...
        // after login is done, maybe put this in the login web service completion block

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Hide keyboard on return press
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailEntry.resignFirstResponder()
        passwordEntry.resignFirstResponder()
        return true
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
