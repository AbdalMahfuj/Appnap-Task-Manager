//
//  TaskListItemTableCell.swift
//  Task Manager
//
//  Created by Mahfuz on 27/6/24.
//

import UIKit

class TaskListItemTableCell: UITableViewCell {

    @IBOutlet private var mainView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var dueDateLabel: UILabel!
    @IBOutlet private var nextImageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func config(toDo: TaskModel) {
        
        titleLabel.text = toDo.title
        dueDateLabel.text = toDo.dueDateString

        if let expire = toDo.dueDate.expireTime {
            dueDateLabel.text = "Expire in: " + expire
            dueDateLabel.textColor = .darkGray
        }
        else {
            dueDateLabel.text = "Expired"
            dueDateLabel.textColor = .systemRed
        }
    }
  
}
