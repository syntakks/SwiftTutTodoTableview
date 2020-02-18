//
//  StubData.swift
//  TodoChecklist
//
//  Created by Stephen Wall on 2/17/20.
//  Copyright © 2020 syntaks.io. All rights reserved.
//

import Foundation

class TodoList {
    var todos: [CheckListItem] = []
    
    init() {
        // Stub data 
        todos.append(CheckListItem(text: "Test1", isChecked: false))
        todos.append(CheckListItem(text: "Test2", isChecked: false))
        todos.append(CheckListItem(text: "Test3", isChecked: false))
        todos.append(CheckListItem(text: "Test4", isChecked: false))
        todos.append(CheckListItem(text: "Test5", isChecked: false))
    }
    
    func newTodo() -> CheckListItem {
        let item = CheckListItem(text: "Test", isChecked: false)
        todos.append(item)
        return item
    }
    
    func move(fromPath: IndexPath, toPath: IndexPath) {
        let item = todos[fromPath.row]
        todos.remove(at: fromPath.row)
        todos.insert(item, at: toPath.row)
    }
    // May need to make this an array of index paths instead. 
    func remove(itemsAt selectedRows: [IndexPath]) {
        var items = [CheckListItem]()
        for indexPath in selectedRows {
            items.append(todos[indexPath.row])
        }
        for item in items {
            if let index = todos.firstIndex(of: item) {
                todos.remove(at: index)
            }
        }
    }
}


