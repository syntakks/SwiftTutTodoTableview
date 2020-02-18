//
//  ViewController.swift
//  TodoChecklist
//
//  Created by Stephen Wall on 2/17/20.
//  Copyright © 2020 syntaks.io. All rights reserved.
//

import UIKit

enum TableViewEvent {
    case loadCell
    case tapCell
}

class CheckListViewController: UITableViewController {
    let todoList = TodoList()
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        deleteButton.title = "" // Doing this here so you can see it in interface builder. 
    }
    
    // MARK: - TableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListCell", for: indexPath)
        let item = todoList.todos[indexPath.row]
        configure(cell: cell, with: item, forEvent: .loadCell)
        return cell
    }
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = todoList.todos[indexPath.row]
            item.toggleIsChecked()
            configure(cell: cell, with: item, forEvent: .tapCell)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.todoList.todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let editItem = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            let item = self.todoList.todos[indexPath.row]
            self.performSegue(withIdentifier: "EditItemSegue", sender: (item, indexPath))
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem, editItem])

        return swipeActions
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(tableView.isEditing, animated: true)
        if editing {
            deleteButton.title = "Delete"
            deleteButton.isEnabled = true
            addButton.isEnabled = false
        } else {
            deleteButton.title = ""
            deleteButton.isEnabled = false
            addButton.isEnabled = true
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        todoList.move(fromPath: sourceIndexPath, toPath: destinationIndexPath)
    }
    
    // MARK: - Delete Items
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            todoList.remove(itemsAt: selectedRows)
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    
    // MARK: - Configure
    func configure(cell: UITableViewCell, with item: CheckListItem, forEvent event: TableViewEvent) {
        if event == .loadCell {
            if let label = cell.viewWithTag(1000) as? UILabel {
                label.text = item.text
            }
        }
        if item.isChecked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddItemSegue" {
            if let addItemController = segue.destination as? ItemViewController {
                addItemController.delegate = self
                addItemController.state = .add
            }
        }
        
        if segue.identifier == "EditItemSegue" {
            if let editItemViewController = segue.destination as? ItemViewController {
                editItemViewController.delegate = self
                editItemViewController.state = .edit
                editItemViewController.editItem = sender as? (CheckListItem, IndexPath)
            }
        }
    }
}

// MARK: - Item View Delegate
extension CheckListViewController: ItemViewControllerDelegate {
    func didCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    func didAdd(item: CheckListItem) {
        navigationController?.popViewController(animated: true)
        let rowIndex = todoList.todos.count
        todoList.todos.append(item)
        let indexPaths = [IndexPath(row: rowIndex, section: 0)]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func didEdit(item: CheckListItem, at indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
        todoList.todos[indexPath.row] = item
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension UINavigationController {
    
}



