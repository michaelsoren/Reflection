//
//  RegisterViewController.swift
//  Reflection
//
//  Created by Michael LeMay on 3/5/19.
//  Copyright © 2019 Steel Fruit Collective. All rights reserved.
//

import UIKit


class RegisterViewController: UIViewController {
    
    
    @IBOutlet private weak var firstName: UILabel!
    @IBOutlet private weak var firstNameField: UITextField!
    @IBOutlet private weak var lastName: UILabel!
    @IBOutlet private weak var lastNameField: UITextField!
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var password: UILabel!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var finish: UIButton!
    @IBOutlet private weak var contentView: UIView!
    
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.viewBackground
        contentView.backgroundColor = Colors.viewBackground
        
        firstName.textColor = Colors.descriptionText
        firstName.font = Fonts.viewDescription
        firstNameField.autocapitalizationType = .words
        
        lastName.textColor = Colors.descriptionText
        lastName.font = Fonts.viewDescription
        lastNameField.autocapitalizationType = .words
        
        email.textColor = Colors.descriptionText
        email.font = Fonts.viewDescription
        
        password.textColor = Colors.descriptionText
        password.font = Fonts.viewDescription
        
        finish.setTitleColor(Colors.descriptionText, for: .normal)
        finish.titleLabel?.font = Fonts.viewDescription
        
        self.hideKeyboardWhenTappedAround()
        
        //Used when preventing keyboard from overlapping with user content
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - Action
    
    
    /*
     * Loads up all the default settings the user provided, if they are valid,
     * then enters the main app if so
     */
    @IBAction private func hitFinished(_ sender: Any) {
        if firstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || lastNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || passwordField.text!.count <= 5 || !emailField.text!.isValidEmail() {
            let errorWarning = UIAlertController(title: "Registration Error", message: "Invalid login info provided. Make sure your email is valid and your password is 6 characters or more.", preferredStyle: UIAlertController.Style.alert)
            let okay = UIAlertAction(title: "Okay", style: .default) { (alertAction) in }
            errorWarning.addAction(okay)
            self.present(errorWarning, animated: true, completion: nil)
        } else {
            UserDefaults.standard.set(emailField.text!, forKey: UserDefaultKeys.email)
            UserDefaults.standard.set(firstName.text!, forKey: UserDefaultKeys.firstName)
            UserDefaults.standard.set(lastName.text!, forKey: UserDefaultKeys.lastName)
            UserDefaults.standard.set(passwordField.text!, forKey: UserDefaultKeys.testingPassword)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarVC = storyboard.instantiateViewController(withIdentifier: "Tab Bar VC")
            
            //Present the date's view controller
            self.present(tabBarVC, animated: true, completion: nil)
        }
    }
    
    
    //Mark: - Keyboard display notifications
    
    
    /*
     * Function to shift view constraints if keyboard appears
     */
    @objc private func keyBoardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject> {
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyBoardRect = frame?.cgRectValue
            if let keyBoardHeight = keyBoardRect?.height {
                self.bottomLayoutConstraint.constant = CGFloat(keyBoardHeight)
                UIView.animate(withDuration: 1.0, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    
    /*
     * Function that resets view constraints if the keyboard appears
     */
    @objc private func keyBoardWillHide(notification: Notification) {
        self.bottomLayoutConstraint.constant = CGFloat(Sizes.registerBottomLayoutConstraint)
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
