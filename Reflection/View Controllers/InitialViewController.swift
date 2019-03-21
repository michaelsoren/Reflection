//
//  InitialViewController.swift
//  Reflection
//
//  Created by Michael LeMay on 3/5/19.
//  Copyright © 2019 Steel Fruit Collective. All rights reserved.
//


import UIKit


class InitialViewController: UIViewController {
    
    @IBOutlet private weak var login: UIButton!
    @IBOutlet private weak var register: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.viewBackground
    }
    
    
    // MARK: - Action
    
    
    /*
     * Displays the login alert controller, if login is possible.
     * If the login is not possible
     */
    @IBAction private func hitLogin(_ sender: Any) {
        if let userEmail = UserDefaults.standard.string(forKey: UserDefaultKeys.email), let userPassword = UserDefaults.standard.string(forKey: UserDefaultKeys.testingPassword) {
            let loginAlert = UIAlertController(title: "Enter your login info", message: "", preferredStyle: UIAlertController.Style.alert)
            
            let login = UIAlertAction(title: "Sign In", style: .default) { (alertAction) in
                let emailField = loginAlert.textFields![0] as UITextField
                let passwordField = loginAlert.textFields![1] as UITextField
                if (emailField.text?.count)! <= 0 {
                    let alert = UIAlertController(title: "Error", message: "Incorrect login info provided", preferredStyle: UIAlertController.Style.alert)
                    let okay = UIAlertAction(title: "Okay", style: .default) { (alertAction) in }
                    alert.addAction(okay)
                    self.present(alert, animated: true, completion: nil)
                    return
                } else if (passwordField.text?.count)! <= 0 {
                    let alert = UIAlertController(title: "Error", message: "Incorrect login info provided", preferredStyle: UIAlertController.Style.alert)
                    let okay = UIAlertAction(title: "Okay", style: .default) { (alertAction) in }
                    alert.addAction(okay)
                    self.present(alert, animated: true, completion: nil)
                    return
                } else {
                    if userEmail == emailField.text! && userPassword == passwordField.text! {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabBarVC = storyboard.instantiateViewController(withIdentifier: "Tab Bar VC")
                        
                        //Present the tab bar view controller to start main app
                        self.present(tabBarVC, animated: true, completion: nil)
                    } else {
                        let errorWarning = UIAlertController(title: "Login Error", message: "Invalid login. Make sure your email and password are correct.", preferredStyle: UIAlertController.Style.alert)
                        let okay = UIAlertAction(title: "Okay", style: .default) { (alertAction) in }
                        errorWarning.addAction(okay)
                        self.present(errorWarning, animated: true, completion: nil)
                    }
                }
            }
            
            loginAlert.addTextField { (promptField) in
                promptField.placeholder = "Enter your email"
                promptField.textColor = Colors.addNewPromptText
            }
            
            loginAlert.addTextField { (promptField) in
                promptField.placeholder = "Enter your password"
                promptField.textColor = Colors.addNewPromptText
                promptField.isSecureTextEntry = true
            }
            
            
            loginAlert.addAction(login)
            
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
            loginAlert.addAction(cancel)
            
            self.present(loginAlert, animated:true, completion: nil)
        } else {
            let errorWarning = UIAlertController(title: "Login Error", message: "You have not registered yet. Please register below.", preferredStyle: UIAlertController.Style.alert)
            let okay = UIAlertAction(title: "Okay", style: .default) { (alertAction) in }
            errorWarning.addAction(okay)
            self.present(errorWarning, animated: true, completion: nil)
        }
    }
    
}
