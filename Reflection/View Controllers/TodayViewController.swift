//
//  FirstViewController.swift
//  Reflection
//
//  Created by Michael LeMay on 3/5/19.
//  Copyright © 2019 Steel Fruit Collective. All rights reserved.
//
// https://stackoverflow.com/questions/43405959/launch-a-local-notification-at-a-specific-time-in-ios
//


import UIKit


class TodayViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var myStackView: UIStackView!
    @IBOutlet private weak var stackViewConstraint: NSLayoutConstraint!
    
    private var entry: Entry = Entry(Prompts: Constants.defaultPrompts)
    private var monthEntry: MonthEntry = MonthEntry()
    private var prompts: [String] = [String]()
    private var originalThoughts: [String] = [String]()
    private var monthEntryService: MonthEntryService = MonthEntryService()
    private var dateForFile: String = ""
    private var dayInt: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        view.backgroundColor = Colors.viewBackground
        contentView.backgroundColor = Colors.viewBackground
        myStackView.backgroundColor = Colors.viewBackground
        
        titleLabel.text = "Today"
        titleLabel.font = Fonts.viewTitle
        titleLabel.textColor = Colors.viewTitle
        
        //Set the date label to the current day
        let todaysDate = Date()
        let calendar = Calendar.current
        let month = String(calendar.component(.month, from: todaysDate))
        let day = String(calendar.component(.day, from: todaysDate))
        let year = String(calendar.component(.year, from: todaysDate))
        dayInt = Int(day)!
        
        prompts = (UserDefaults.standard.stringArray(forKey: UserDefaultKeys.prompts))!
        originalThoughts = Array(repeating: "", count: prompts.count)
        
        let todayString = month + "/" + day + "/" + year
        dateForFile = month + "-" + day + "-" + year
        monthEntryService.getMonthEntry(Month: month, Year: year, completion: {
            monthEntry, error in
            
            guard let gotMonthEntry = monthEntry, error == nil else {
                perror("Error occured fetching entry " + self.dateForFile + ".json")
                return
            }
            self.monthEntry = gotMonthEntry
            if self.monthEntry.daysWithEntry.contains(self.dayInt) {
                //Last entry in month will always be the one I'm editing today
                self.entry = self.monthEntry.entries[self.dayInt - 1]
            }
            //fix entry prompts to current userdefault prompts
            if !self.entry.prompts.containsSameElements(as: self.prompts) {
                var newThoughts = [String]()
                for prompt in self.prompts {
                    if !self.entry.prompts.contains(prompt) {
                        newThoughts.append("")
                    } else {
                        let indexOfPrompt = self.entry.prompts.firstIndex(of: prompt)
                        newThoughts.append(self.entry.thoughts[indexOfPrompt!])
                    }
                }
                
                self.entry.prompts = self.prompts
                self.entry.thoughts = newThoughts
            }
            self.layoutPrompts()
        })
        
        
        dateLabel.text = todayString
        dateLabel.textColor = Colors.dateText
        dateLabel.font = Fonts.date
        
        myStackView.spacing = Sizes.promptThoughtStackSpacing
        
        self.hideKeyboardWhenTappedAround()
        
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.shouldDisplayAbout) {
            self.shouldShowAbout()
        }
        if (!UserDefaults.standard.bool(forKey: UserDefaultKeys.hasAskedAboutNotifications)) {
            UserDefaults.standard.set(true, forKey: UserDefaultKeys.hasAskedAboutNotifications)
            InternalNotificationHandler.reminderRequestAndSetup()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let reloadPrompts = (UserDefaults.standard.stringArray(forKey: UserDefaultKeys.prompts))!
        if !reloadPrompts.containsSameElements(as: prompts) {
            //reset original thoughts
            originalThoughts = Array(repeating: "", count: reloadPrompts.count)
            var newEntry = Entry(Prompts: reloadPrompts)
            //Puts old prompt entries into the new prompt entries if the prompts
            //match, so that user entries are not deleted by changing the prompts
            //if the prompts are unchanged
            for (i, newPrompt) in newEntry.prompts.enumerated() {
                if entry.prompts.contains(newPrompt) {
                    let findIndex = (entry.prompts.index(of: newPrompt))!
                    newEntry.thoughts[i] = entry.thoughts[findIndex]
                } else {
                    newEntry.thoughts[i] = ""
                }
            }
            entry = newEntry
            prompts = reloadPrompts
            layoutPrompts()
        }
        
        //Used when preventing keyboard from overlapping with user content
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    //Mark: - Keyboard display notifications
    
    
    /*
     * Shift the constraints so they keyboard doesn't cover any prompts
     */
    @objc private func keyBoardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject> {
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyBoardRect = frame?.cgRectValue
            if let keyBoardHeight = keyBoardRect?.height {
                self.stackViewConstraint.constant = CGFloat(keyBoardHeight)
                UIView.animate(withDuration: 1.0, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    
    /*
     * Animate the keyboard away and reset the constraints
     */
    @objc private func keyBoardWillHide(notification: Notification) {
        self.stackViewConstraint.constant = CGFloat(Sizes.todayViewStackViewBottomConstraint)
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    //Mark: - UITextViewDelegate
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type your thoughts here..." {
            originalThoughts[textView.tag] = "Type your thoughts here..."
            textView.text = ""
            textView.textColor = Colors.thoughtBoxText
        } else {
            originalThoughts[textView.tag] = textView.text
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Type your thoughts here..."
            textView.textColor = Colors.thoughtDefaultTextColor
            entry.thoughts[textView.tag] = ""
        } else {
            entry.thoughts[textView.tag] = textView.text
            textView.textColor = Colors.thoughtBoxText
            //updates the json off of the main queue
        }
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) != originalThoughts[textView.tag] {
            //updates json off of main queue to whatever the new text is
            monthEntryService.setMonthEntry(Day: dayInt, Entry: entry, MonthEntry: monthEntry) {
                monthEntry, error in
                guard let gotMonthEntry = monthEntry, error == nil else {
                    perror("Error occured fetching entry " + self.dateForFile + ".json")
                    return
                }
                self.monthEntry = gotMonthEntry
                if self.monthEntry.daysWithEntry.contains(self.dayInt) {
                    self.entry = self.monthEntry.entries[self.dayInt - 1]
                }
                self.layoutPrompts()
            }
        }
    }
    
    
    //Mark: - Helper functions
    
    
    /*
     * Shows about view over today view upon first opening of the app
     */
    private func shouldShowAbout() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let temporaryDateVC = storyboard.instantiateViewController(withIdentifier: "About") as! AboutViewController
        temporaryDateVC.modalTransitionStyle = .crossDissolve
        temporaryDateVC.modalPresentationStyle = .overCurrentContext
        
        //Present the date's view controller
        self.present(temporaryDateVC, animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.shouldDisplayAbout)
    }
    
    
    /*
     * Lay out the prompt/thought pairs in a stack view, then
     * add that to the larger stack view
     */
    private func layoutPrompts() {
        //Remove old subviews
        myStackView.subviews.forEach({$0.removeFromSuperview()})
        for (i, prompt) in entry.prompts.enumerated() {
            
            let newPrompt = UILabel()
            newPrompt.text = prompt
            newPrompt.textColor = Colors.promptText
            newPrompt.font = Fonts.promptFont
            newPrompt.numberOfLines = 0
            newPrompt.tag = i
            
            let newThoughtView = UITextView()
            newThoughtView.text = entry.thoughts[i] == "" ? "Type your thoughts here..." : entry.thoughts[i]
            newThoughtView.textColor = entry.thoughts[i] == "" ? Colors.thoughtDefaultTextColor : Colors.thoughtBoxText
            newThoughtView.font = Fonts.thoughtFont
            newThoughtView.backgroundColor = Colors.viewBackground
            newThoughtView.layer.borderWidth = Sizes.thoughtBoxBorderWidth
            newThoughtView.layer.borderColor = Colors.viewItemBorder.cgColor
            newThoughtView.layer.cornerRadius = Sizes.thoughtBoxBorderRoundedCorners
            newThoughtView.delegate = self
            newThoughtView.heightAnchor.constraint(greaterThanOrEqualTo: newThoughtView.widthAnchor, multiplier: 1.0/2.0).isActive = true
            newThoughtView.tag = i
            
            let newStackView = UIStackView()
            newStackView.axis = .vertical
            newStackView.spacing = Sizes.pairStackSpacing
            newStackView.addArrangedSubview(newPrompt)
            newStackView.addArrangedSubview(newThoughtView)
            
            myStackView.addArrangedSubview(newStackView)
        }
    }
    
}

