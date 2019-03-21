//
//  SecondViewController.swift
//  Reflection
//
//  Created by Michael LeMay on 3/5/19.
//  Copyright © 2019 Steel Fruit Collective. All rights reserved.
//
// Drawn from: https://www.youtube.com/watch?v=srJj8U5d5ok
//

import UIKit

protocol monthViewDelegate: class {
    func didChangeMonth(monthIndex: Int, year: Int)
}


class PastViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    
    private var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    private var entries = [Int : (String, String)]()
    private var currentMonth = 0
    private var currentYear = 0
    private var startMonth = 0
    private var startYear = 0
    private var todaysDate = 0
    private var firstWeekDayOfMonth = 0
    private let monthEntryService: MonthEntryService = MonthEntryService()
    private var monthEntry: MonthEntry = MonthEntry()
    
    //Init views
    private let monthView: MonthView = MonthView()
    private let weekView: WeekView = WeekView()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Past"
        titleLabel.textColor = Colors.dateText
        titleLabel.font = Fonts.viewTitle
        
        view.backgroundColor = Colors.viewBackground
        
        contentView.backgroundColor = Colors.viewBackground
        
        contentView.layer.borderWidth = Sizes.calendarBorderWidth
        contentView.layer.cornerRadius = Sizes.calendarCornerRadius
        contentView.layer.borderColor = Colors.viewItemBorder.cgColor
        
        let date = Date()
        
        currentMonth = Calendar.current.component(.month, from: date)
        currentYear = Calendar.current.component(.year, from: date)
        todaysDate = Calendar.current.component(.day, from: date)
        firstWeekDayOfMonth = getFirstWeekDay()
        
        //Fix for leap years
        if currentMonth == 2 && currentYear % 4 == 0 {
            daysInMonth[currentMonth - 1] = Constants.leapYearFeb
        }
        
        startMonth = currentMonth
        startYear = currentYear
        
        contentView.addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        monthView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        monthView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        monthView.heightAnchor.constraint(equalToConstant: Sizes.monthViewHeightAnchor).isActive = true
        monthView.delegate = self
        
        contentView.addSubview(weekView)
        weekView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive = true
        weekView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        weekView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        weekView.heightAnchor.constraint(equalToConstant: Sizes.weekViewHeightAnchor).isActive = true
        
        contentView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: weekView.bottomAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "Cell")
        
        monthEntryService.getMonthEntry(Month: String(currentMonth), Year: String(currentYear), completion: {
            monthEntry, error in
            guard let gotMonthEntry = monthEntry, error == nil else {
                perror("Error occured fetching entry " + String(self.currentMonth) + "-" + String(self.currentYear) + ".json")
                return
            }
            self.monthEntry = gotMonthEntry
            self.collectionView.reloadData()
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monthEntryService.getMonthEntry(Month: String(currentMonth), Year: String(currentYear), completion: {
            monthEntry, error in
            guard let gotMonthEntry = monthEntry, error == nil else {
                perror("Error occured fetching entry " + String(self.currentMonth) + "-" + String(self.currentYear) + ".json")
                return
            }
            self.monthEntry = gotMonthEntry
            self.collectionView.reloadData()
        })
    }
    
    
    //Mark : - Collection View Delegate
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth[currentMonth - 1] + firstWeekDayOfMonth - 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //get the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DateCell
        //initialize the cell
        cell.backgroundColor = UIColor.clear
        //calculate whether I should show this cell
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden = true
        } else {
            let calcDate = indexPath.row - firstWeekDayOfMonth + 2
            cell.isHidden = false
            cell.button.setTitle("\(calcDate)", for: .normal)
            cell.button.setTitleColor(Colors.calendarEntryTextData, for: .normal)
            cell.button.tag = indexPath.row
            cell.isUserInteractionEnabled = true
            cell.button.isUserInteractionEnabled = true
            
            cell.button.addTarget(self, action: #selector(tappedDateAction(sender:)), for: .touchUpInside)
            
            if monthEntry.daysWithEntry.contains(calcDate) {
                cell.isUserInteractionEnabled = true
                cell.button.setTitleColor(Colors.calendarEntryTextData, for: .normal)
            } else {
                cell.isUserInteractionEnabled = false
                cell.button.setTitleColor(Colors.calendarEntryTextNoData, for: .normal)
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / Sizes.dayEntryMultiplier, height: collectionView.frame.width / Sizes.dayEntryMultiplier)
    }
    
    
    //Mark : - MonthViewDelegate
    
    
    /*
     * When the month is changed, updates the collection view to display
     * the new month
     */
    func didChangeMonth(month: Int, year: Int) {
        currentYear = year
        currentMonth = month + 1
        
        //for leap year, make february month of 29 days
        if month == 1 {
            if currentYear % 4 == 0 {
                daysInMonth[month] = Constants.leapYearFeb
            } else {
                daysInMonth[month] = Constants.februaryDays
            }
        }
        
        firstWeekDayOfMonth = getFirstWeekDay()
        collectionView.reloadData()
        
        monthView.right.isEnabled = !(currentMonth == startMonth && currentYear == startYear)
        
        monthEntryService.getMonthEntry(Month: String(currentMonth), Year: String(currentYear), completion: {
            monthEntry, error in
            guard let gotMonthEntry = monthEntry, error == nil else {
                perror("Error occured fetching entry " + String(self.currentMonth) + "-" + String(self.currentYear) + ".json")
                return
            }
            self.monthEntry = gotMonthEntry
            self.collectionView.reloadData()
        })
    }
    
    
    //Mark : - Helper functions
    
    
    /*
     * Returns the first day of the week (as an index) for a given month
     */
    private func getFirstWeekDay() -> Int {
        let day = ("\(currentYear) - \(currentMonth)-01".date?.firstDayOfMonth.weekday)!
        return day == 7 ? 1 : day
    }
    
    
    /*
     * When you tap a date, loads that entry in a view controller for you
     */
    @objc private func tappedDateAction(sender: UIButton) {
        //Animate an entry sliding onto the screen.
        //Figure out what date this is for
        let daySelected = String(sender.tag - firstWeekDayOfMonth + 2)
        let monthSelected = currentMonth
        let yearSelected = currentYear
        
        //Create the popup view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let temporaryDateVC = storyboard.instantiateViewController(withIdentifier: "Popup View Controller") as! PastEntryViewController
        temporaryDateVC.selectedDate = "\(monthSelected)/\(daySelected)/\(yearSelected)"
        temporaryDateVC.pastEntry = monthEntry.entries[sender.tag - firstWeekDayOfMonth + 1]
        temporaryDateVC.modalTransitionStyle = .crossDissolve
        temporaryDateVC.modalPresentationStyle = .overCurrentContext
        
        //Present the date's view controller
        self.present(temporaryDateVC, animated: true, completion: nil)
    }
}

