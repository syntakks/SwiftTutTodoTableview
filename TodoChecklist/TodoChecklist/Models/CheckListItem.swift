//
//  CheckListItem.swift
//  TodoChecklist
//
//  Created by Stephen Wall on 2/17/20.
//  Copyright © 2020 syntaks.io. All rights reserved.
//

import Foundation

class CheckListItem: Equatable {
    static func == (lhs: CheckListItem, rhs: CheckListItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    var text: String = ""
    var isChecked: Bool = false
    
    init(text: String, isChecked: Bool) {
        self.text = text
        self.isChecked = isChecked
    }
    
    func toggleIsChecked() {
        isChecked = !isChecked
    }
}
