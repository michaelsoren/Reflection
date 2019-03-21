//
//  AppDelegate.swift
//  Reflection
//
//  Created by Michael LeMay on 3/5/19.
//  Copyright © 2019 Steel Fruit Collective. All rights reserved.
//

import UIKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var shouldDisplaySplash: Bool = false
    private var splashViewController: UIViewController = UIViewController()
    
    let splashScreenDisplay = 2.0
    
    
    /*
     * Loads up all the default settings if necessary, and also
     * Will display the app store review request if relevant.
     */
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        shouldDisplaySplash = true
        if let _ = UserDefaults.standard.object(forKey: UserDefaultKeys.launchedBefore) {
            let numLaunches = UserDefaults.standard.integer(forKey: UserDefaultKeys.numLaunches)
            if numLaunches == 2 {
                //Displays the review request, since this is the third launch
                SKStoreReviewController.requestReview()
            }
            UserDefaults.standard.set(numLaunches + 1, forKey: UserDefaultKeys.numLaunches)
        } else {
            UserDefaults.standard.set(true, forKey: UserDefaultKeys.launchedBefore)
            
            UserDefaults.standard.set(Constants.defaultPrompts, forKey: UserDefaultKeys.prompts)
            
            //Set this date as the initial launch date. Updates settings bundle to reflect the start date
            let today = Date()
            let dF = DateFormatter()
            dF.dateFormat = "MM/dd/yyyy"
            let initialLaunchDate = dF.string(for: today)!
            
            UserDefaults.standard.set(initialLaunchDate, forKey: UserDefaultKeys.launchDate)
            
            //Set the launch count to zero, since they just started
            UserDefaults.standard.set(0, forKey: UserDefaultKeys.numLaunches)
            
            //Display about on first login
            UserDefaults.standard.set(true, forKey: UserDefaultKeys.shouldDisplayAbout)
            
            //List of dates that have valid entries. Will eventually be replaced
            UserDefaults.standard.set([String](), forKey: UserDefaultKeys.entriesList)
            UserDefaults.standard.set(true, forKey: UserDefaultKeys.shouldSendNotifications)
            UserDefaults.standard.set(false, forKey: UserDefaultKeys.hasAskedAboutNotifications)
            UserDefaults.standard.set(Date(), forKey: UserDefaultKeys.reminderTime)
        }
        return true
    }
    
    
    /*
     * When application vecomes active, displays the launch screen for the scheduled time
     * interval
     */
    func applicationDidBecomeActive(_ application: UIApplication) {
        if shouldDisplaySplash {
            let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
            splashViewController = storyboard.instantiateViewController(withIdentifier: "LaunchScreen")
            self.window!.rootViewController!.present(splashViewController, animated: false, completion:
                {
                    self.shouldDisplaySplash = false
                    Timer.scheduledTimer(timeInterval: self.splashScreenDisplay, target: self, selector: #selector(self.removeSplashViewController), userInfo: nil, repeats: false)
            })
        }
    }
    
    
    //Mark: - Helper functions
    
    
    /*
     * Function that dismisses the splash view controller
     */
    @objc private func removeSplashViewController() {
        self.splashViewController.dismiss(animated: false, completion: nil)
    }
}

