//
//  Enums.swift
//  Task Manager
//
//  Created by Mahfuz on 27/6/24.
//

import UIKit


enum Storyboard: String {
    case main
    
    var filename: String {
        return rawValue.capitalized
    }
}

enum ChangeStatus: Int {
    case created = 1
    case updated
    case deleted
    case synced
}

