//
//  dateCell.swift
//  Reflection
//
//  Created by Michael LeMay on 3/6/19.
//  Copyright © 2019 Steel Fruit Collective. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class dateCell: UICollectionViewCell {

    let label: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 16)
        label.textColor=Colors.calendarTextColor
        label.translatesAutoresizingMaskIntoConstraints=false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        
        addSubview(label)
        
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
