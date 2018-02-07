//
//  LoginViewController.swift
//  Parse Chat
//
//  Created by Shaurya Sinha on 31/01/18.
//  Copyright © 2018 Shaurya Sinha. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBAction func onSignIn(_ sender: Any) {
        if((usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)!){
            let alertController = UIAlertController(title: "Missing Fields", message: "Please enter Username and Password", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                
            }
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true) {
                
            }
        }else{
            let username = usernameField.text ?? ""
            let password = passwordField.text ?? ""
            
            PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
                if let error = error {
                    print("User log in failed: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: "Please check username and password", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        
                    }
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true) {
                        
                    }
                    
                } else {
                    print("User logged in successfully")
                    // display view controller that needs to shown after successful login
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
            
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        if((usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)!){
            let alertController = UIAlertController(title: "Missing Fields", message: "Please enter Username and Password", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                
            }
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true) {
                
            }
        }else{
            let newUser = PFUser()
            
            // set user properties
            newUser.username = usernameField.text
            //newUser.email = emailLabel.text
            newUser.password = passwordField.text
            
            // call sign up function on the object
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                    let alertController = UIAlertController(title: "Signup Error", message: "Please enter valid username and password", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        
                    }
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true) {
                        
                    }
                } else {
                    print("User Registered successfully")
                    // manually segue to logged in view
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
            
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let currentUser = PFUser.current() {
            print("Welcome back \(currentUser.username!) 😀")
            
            // TODO: Load Chat view controller and set as root view
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
}
