//
//  AboutViewController.swift
//  Reflection
//
//  Created by Michael LeMay on 3/10/19.
//  Copyright © 2019 Steel Fruit Collective. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textBlockOne: UILabel!
    @IBOutlet private weak var textBlockTwo: UILabel!
    @IBOutlet private weak var textBlockThree: UILabel!
    @IBOutlet private weak var signatureLabel: UILabel!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.popupBackgroundColor
        
        popupView.backgroundColor = Colors.viewBackground
        popupView.layer.cornerRadius = Sizes.popupCornerRadius
        popupView.layer.borderColor = Colors.viewItemBorder.cgColor
        popupView.layer.borderWidth = Sizes.thoughtBoxBorderWidth
        popupView.layer.masksToBounds = true
        
        contentView.backgroundColor = Colors.viewBackground
        
        titleLabel.textColor = Colors.viewTitle
        titleLabel.font = Fonts.viewTitle
        
        textBlockOne.textColor = Colors.descriptionText
        textBlockOne.font = Fonts.viewDescription
        
        textBlockTwo.textColor = Colors.descriptionText
        textBlockTwo.font = Fonts.viewDescription
        
        textBlockThree.textColor = Colors.descriptionText
        textBlockThree.font = Fonts.viewDescription
        
        signatureLabel.textColor = Colors.descriptionText
        signatureLabel.font = Fonts.viewDescription
        
        dismissButton.setTitleColor(Colors.buttonTextSelected, for: .normal)
    }
    
    //This prevents users from causing blackscreen by leaving
    //popup view without closing popup
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismiss(animated: false, completion: nil)
    }
    
    
    /*
     * Function that just dismisses the about view
     */
    @IBAction private func dismissAboutView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
