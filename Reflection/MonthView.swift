//
//  MonthView.swift
//  Reflection
//
//  Created by Michael LeMay on 3/6/19.
//  Copyright © 2019 Steel Fruit Collective. All rights reserved.
//
// Code inspired by and drawn from this source: https://www.youtube.com/watch?v=srJj8U5d5ok
//

import UIKit

protocol MonthViewDelegate: class {
    func didChangeMonth(monthIndex: Int, year: Int)
}

class MonthView: UIView {

    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentMonth = 0
    var currentYear = 0
    var delegate: MonthViewDelegate?
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Default text"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let left: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(leftRightAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    let right: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(leftRightAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //setup month view
        self.backgroundColor = UIColor.clear
        //calculate current date info
        currentMonth = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        //setup subviews
        setupViews()
        //adjust anything else
        right.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func leftRightAction(sender: UIButton) {
        if sender == right {
            currentMonth += 1
            if currentMonth > 11 {
                currentMonth = 0
                currentYear += 1
            }
            
        } else if sender == left {
            currentMonth -= 1
            if currentMonth < 0 {
                currentMonth = 11
                currentYear -= 1
            }
            
        }
        dateLabel.text = "\(months[currentMonth]) \(currentYear)"
        delegate?.didChangeMonth(monthIndex: currentMonth, year: currentYear)
    }
    
    func setupViews() {
        self.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        dateLabel.text = "\(months[currentMonth]) \(currentYear)"
            
        self.addSubview(right)
        right.topAnchor.constraint(equalTo: topAnchor).isActive = true
        right.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        right.heightAnchor.constraint(equalToConstant: 50).isActive = true
        right.widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        
        self.addSubview(left)
        left.topAnchor.constraint(equalTo: topAnchor).isActive = true
        left.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        left.heightAnchor.constraint(equalToConstant: 50).isActive = true
        left.widthAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
}
