//
//  EditPromptsViewController.swift
//  Reflection
//
//  Created by Michael LeMay on 3/8/19.
//  Copyright © 2019 Steel Fruit Collective. All rights reserved.
//
// https://stackoverflow.com/questions/26567413/get-input-value-from-textfield-in-ios-alert-in-swift
//

import UIKit

class EditPromptsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var popupView: UIView!
    @IBOutlet private weak var promptTable: UITableView!
    @IBOutlet private weak var addPromptButton: UIButton!
    @IBOutlet private weak var dismissButton: UIButton!
    
    
    var prompts: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.popupBackgroundColor
        
        popupView.layer.cornerRadius = Sizes.popupCornerRadius
        popupView.layer.masksToBounds = true
        
        promptTable.delegate = self
        promptTable.dataSource = self
        
        prompts = (UserDefaults.standard.array(forKey: "prompts") as? [String]) ?? Constants.defaultPrompts
        
        promptTable.rowHeight = UITableView.automaticDimension
        promptTable.estimatedRowHeight = Sizes.estimatedRowHeight
    }
    
    
    //This prevents users from causing blackscreen by leaving
    //popup view without closing popup
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismiss(animated: false, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prompts.count
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PromptTableViewCell else { fatalError("The dequeued cell is not an instance of MovieTableViewCell.") }
        
        let prompt = prompts[indexPath.row]
        
        cell.promptText.text = prompt
        cell.promptText.font = Fonts.promptEditFont
        cell.promptText.textColor = Colors.settingsPromptText
        
        return cell
    }
    
    
    // MARK: - Table view methods
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            if prompts.count > 1 {
                //This prevents the user from emptying all the prompts, which
                //would remove the point of the app.
                prompts.remove(at: indexPath.row)
                promptTable.reloadData()
            } else {
                let alert = UIAlertController(title: "Cannot Remove Last Prompt", message: "You need to have at least one prompt to respond to.", preferredStyle: UIAlertController.Style.alert)
                let okay = UIAlertAction(title: "Okay", style: .default) { (alertAction) in }
                alert.addAction(okay)
                
                self.present(alert, animated:true, completion: nil)
            }
        }
    }
    
    
    // MARK: - Actions
    
    
    /*
     * Dismisses the current view, but not before saving the new prompts
     * to user defaults
     */
    @IBAction private func dismissEditPopup(_ sender: Any) {
        //First update user defaults to store these new prompts
        UserDefaults.standard.set(prompts, forKey: "prompts")
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
     * Adds a prompt to the view using an alert controller
     */
    @IBAction private func addPrompt(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Prompt", message: "This prompt will be added to your daily reflection", preferredStyle: UIAlertController.Style.alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let promptField = alert.textFields![0] as UITextField
            if promptField.text != "" {
                self.prompts.append(promptField.text!)
                self.promptTable.reloadData()
            }
        }
        
        alert.addTextField { (promptField) in
            promptField.placeholder = "Enter your new prompt"
            promptField.textColor = Colors.addNewPromptText
        }
        
        alert.addAction(save)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        alert.addAction(cancel)
        
        self.present(alert, animated:true, completion: nil)
        
    }
}
