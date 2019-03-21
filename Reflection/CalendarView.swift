//
//  CalendarView.swift
//  Reflection
//
//  Created by Michael LeMay on 3/6/19.
//  Copyright © 2019 Steel Fruit Collective. All rights reserved.
//
/*
import UIKit

class CalendarView: UIView {
    
    var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var currentMonth = 0
    var currentYear = 0
    var presentMonth = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0

    let monthView: MonthView = {
        let mV = MonthView()
        mV.translatesAutoresizingMaskIntoConstraints = false
        return mV
    }()
    
    let weekView: WeekView = {
        let wV = WeekView()
        wV.translatesAutoresizingMaskIntoConstraints = false
        return wV
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        //setup date info
        currentMonth = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth = getFirstWeekDay()
        
        //Fix for leap years
        if currentMonth == 2 && currentYear % 4 == 0 {
            daysInMonth[currentMonth - 1] = 29
        }
        
        presentMonth = currentMonth
        presentYear = currentYear
        
        addSubview(weekView)
        weekView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive = true
        weekView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        weekView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        weekView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: weekView.bottomAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        monthView.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    //Mark : - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth[currentMonth - 1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //get the cell
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DateCell
        //initialize the cell
        cell.backgroundColor=UIColor.clear
        //calculate whether I should show this cell
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden=true
        } else {
            let calcDate = indexPath.row-firstWeekDayOfMonth + 2
            cell.isHidden=false
            cell.label.text="\(calcDate)"
            if calcDate < todaysDate && currentYear == presentYear && currentMonth == presentMonth {
                cell.isUserInteractionEnabled=false
                cell.label.textColor = Colors.calendarTextColorEntry
            } else {
                cell.isUserInteractionEnabled=true
                cell.label.textColor = Colors.calendarTextColorNoEntry
            }
        }
        return cell
    }
    
    func didChangeMonth(month: Int, year: Int) {
        currentYear = year
        currentMonth = month + 1
        
        //for leap year, make february month of 29 days
        if month == 1 {
            if currentYear % 4 == 0 {
                daysInMonth[month] = 29
            } else {
                daysInMonth[month] = 28
            }
        }
        //end
        
        firstWeekDayOfMonth = getFirstWeekDay()
        
        collectionView.reloadData()
        
        monthView.left.isEnabled = !(currentMonth == presentMonth && currentYear == presentYear)
    }

    
    //Mark : - Helper functions
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear) - \(currentMonth)-01".date?.firstDayOfMonth.weekday)!
        return day == 7 ? 1 : day
    }
}
*/
