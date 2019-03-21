//
//  EditReminderTimeViewController.swift
//  Reflection
//
//  Created by Michael LeMay on 3/8/19.
//  Copyright © 2019 Steel Fruit Collective. All rights reserved.
//
// https://stackoverflow.com/questions/41674497/get-date-from-date-picker-to-string-in-a-variable
//


import UIKit
import UserNotifications


class EditReminderTimeViewController: UIViewController {
    
    @IBOutlet private weak var timePicker: UIDatePicker!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var popupView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.popupBackgroundColor
        
        if UserDefaults.standard.object(forKey: UserDefaultKeys.reminderTime) != nil {
            self.timePicker.date = UserDefaults.standard.value(forKey: UserDefaultKeys.reminderTime) as! Date
        }
        
        popupView.layer.cornerRadius = Sizes.popupCornerRadius
        popupView.layer.masksToBounds = true
    }
    
    
    //This prevents users from causing blackscreen by leaving
    //popup view without closing popup
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction private func dismissTimePickerView(_ sender: Any) {
        UserDefaults.standard.setValue(timePicker.date, forKey: UserDefaultKeys.reminderTime)
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.shouldSendNotifications) {
            InternalNotificationHandler.setNotification()
        }
        dismiss(animated: true, completion: nil)
    }
}
