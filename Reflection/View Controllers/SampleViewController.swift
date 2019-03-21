//
//  SampleViewController.swift
//  Reflection
//
//  Created by Michael LeMay on 3/5/19.
//  Copyright © 2019 Steel Fruit Collective. All rights reserved.
//

import UIKit


class SampleViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var myStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noSamplesLabel: UILabel!
    
    private let monthEntryService: MonthEntryService = MonthEntryService()
    private var monthEntry: MonthEntry = MonthEntry()
    private var entry: Entry = Entry(Prompts: Constants.defaultPrompts)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.backgroundColor = Colors.viewBackground
        myStackView.backgroundColor = Colors.viewBackground
        view.backgroundColor = Colors.viewBackground
        
        titleLabel.text = "Remember"
        titleLabel.textColor = Colors.viewTitle
        titleLabel.font = Fonts.viewTitle
        
        //Randomly generate the day
        guard let (randomDay, randomMonth, randomYear) = generateRandomDate() else {
            dateLabel.isHidden = true
            noSamplesLabel.text = "No entries to remember right now."
            noSamplesLabel.textColor = Colors.descriptionText
            noSamplesLabel.font = Fonts.viewDescription
            noSamplesLabel.isHidden = false
            return
        }
        noSamplesLabel.isHidden = true
        
        dateLabel.isHidden = false
        dateLabel.text = "On " + randomMonth + "/" + randomYear
        dateLabel.textColor = Colors.descriptionText
        dateLabel.font = Fonts.viewDescription
        
        myStackView.spacing = Sizes.promptThoughtStackSpacing
        
        monthEntryService.getMonthEntry(Month: randomMonth, Year: randomYear, completion: {
            monthEntry, error in
            guard let gotMonthEntry = monthEntry, error == nil else {
                perror("Error occured fetching entry " + randomMonth + "-" + randomYear + ".json")
                return
            }
            self.monthEntry = gotMonthEntry
            self.dateLabel.text = "On " + randomMonth + "/" + String(randomDay) + "/" + randomYear + ":"
            self.entry = self.monthEntry.entries[randomDay - 1]
            self.layoutPrompts()
        })
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let (randomDay, randomMonth, randomYear) = generateRandomDate() else {
            dateLabel.isHidden = true
            noSamplesLabel.text = "No entries to remember right now."
            noSamplesLabel.textColor = Colors.descriptionText
            noSamplesLabel.font = Fonts.viewDescription
            noSamplesLabel.isHidden = false
            return
        }
        monthEntryService.getMonthEntry(Month: randomMonth, Year: randomYear, completion: {
            monthEntry, error in
            guard let gotMonthEntry = monthEntry, error == nil else {
                perror("Error occured fetching entry " + randomMonth + "-" + randomYear + ".json")
                return
            }
            self.monthEntry = gotMonthEntry
            
            self.noSamplesLabel.isHidden = true
            self.dateLabel.isHidden = false
            self.dateLabel.text = "On " + randomMonth + "/" + String(randomDay) + "/" + randomYear + ":"
            self.entry = self.monthEntry.entries[randomDay - 1]
            self.layoutPrompts()
        })
    }
    
    
    //Mark: - Helper functions
    
    
    /*
     * Function returns a randomly chosen day, month, and year
     * from the userdefault list of dates with entry.
     * Long term, this info will be stored in a server, rather
     * than in user defaults.
     */
    private func generateRandomDate() -> (Int, String, String)? {
        let possibleDates = UserDefaults.standard.stringArray(forKey: UserDefaultKeys.entriesList)

        if let possibleDates = possibleDates {
            if possibleDates.isEmpty {
                return nil
            } else {
                let r = Int.random(in: 0..<possibleDates.count)
                let selectedDate = possibleDates[r]
                let splitDate = selectedDate.split(separator: "-")
                let day = Int(splitDate[0])!
                let month = String(splitDate[1])
                let year = String(splitDate[2])
                return (day, month, year)
            }
        }
        return nil
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
            
            let newThoughtView = UITextView()
            newThoughtView.text = entry.thoughts[i]
            newThoughtView.textColor = Colors.thoughtBoxText
            newThoughtView.font = Fonts.thoughtFont
            newThoughtView.backgroundColor = Colors.viewBackground
            newThoughtView.layer.borderWidth = Sizes.thoughtBoxBorderWidth
            newThoughtView.layer.borderColor = Colors.viewItemBorder.cgColor
            newThoughtView.layer.cornerRadius = Sizes.thoughtBoxBorderRoundedCorners
            newThoughtView.delegate = self
            newThoughtView.isEditable = false
            newThoughtView.heightAnchor.constraint(greaterThanOrEqualTo: newThoughtView.widthAnchor, multiplier: 1.0/2.0).isActive = true
            
            let newStackView = UIStackView()
            newStackView.axis = .vertical
            newStackView.spacing = Sizes.pairStackSpacing
            newStackView.addArrangedSubview(newPrompt)
            newStackView.addArrangedSubview(newThoughtView)
            
            myStackView.addArrangedSubview(newStackView)
        }
    }
    
}
