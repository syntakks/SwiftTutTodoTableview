//
//  AddItemViewController.swift
//  TodoChecklist
//
//  Created by Stephen Wall on 2/17/20.
//  Copyright © 2020 syntaks.io. All rights reserved.
//

import UIKit
// MARK: - State
enum ControllerState {
    case add
    case edit
}
// MARK: - ItemViewControllerDelegate
protocol ItemViewControllerDelegate: class {
    func didCancel()
    func didAdd(item: CheckListItem)
    func didEdit(item: CheckListItem, at indexPath: IndexPath)
}

class ItemViewController: UIViewController {
    weak var delegate: ItemViewControllerDelegate?
    var state: ControllerState?
    var editItem: (item: CheckListItem, indexPath: IndexPath)?
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var updateBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    // MARK: - Configure
    
    func configureView() {
        switch state {
        case .add:
            navigationItem.title = "New Todo"
            updateBarButton.title = "Add"
        case .edit:
            navigationItem.title = "Edit Todo"
            updateBarButton.title = "Update"
            if let editItem = editItem {
                textField.text = editItem.item.text
            }
        default:
            navigationItem.title = "New Todo"
            updateBarButton.title = "Add"
        }
    }
    
    // MARK: - Button Actions
    @IBAction func cancel(_ sender: Any) {
        delegate?.didCancel()
    }
    
    // Add or Edit button.
    @IBAction func update(_ sender: Any) {
        itemUpdate()
    }
    
    // MARK: - Create & Edit Item Methods
    func itemUpdate() {
        switch state {
        case .add:
            createNewItem()
        case .edit:
            editExistingItem()
        default:
            print("Woops")
        }
    }
    
    func createNewItem() {
        if let text = textField.text {
            let item = CheckListItem(text: text, isChecked: false)
            delegate?.didAdd(item: item)
        }
    }
    
    func editExistingItem() {
        if let editItem = editItem {
            let item = editItem.item
            let indexPath = editItem.indexPath
            // Text field has text
            guard let textFieldText = textField.text else {
                delegate?.didCancel()
                return
            }
            // If the text matches the old value, just cancel
            if item.text == textField.text || textFieldText.count < 1 {
                delegate?.didCancel()
                return
            }
            // Update the item
            item.text = textFieldText
            delegate?.didEdit(item: item, at: indexPath)
        }
        
    }
    
}

// MARK: - Text Field Delegate
extension ItemViewController: UITextFieldDelegate {
    // Done button from keyboard tapped.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemUpdate()
        return true
    }
    
    // Catches changes to text field.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text,
            let stringRange = Range(range, in: oldText) else {
                return false
        }
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            updateBarButton.isEnabled = false
        } else {
            updateBarButton.isEnabled = true
        }
        return true
    }
}
