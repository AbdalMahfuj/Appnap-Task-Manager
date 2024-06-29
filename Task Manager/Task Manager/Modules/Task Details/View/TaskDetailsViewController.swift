//
//  TaskDetailsViewController.swift
//  Task Manager
//
//  Created by Mahfuz on 27/6/24.
//

import UIKit

class TaskDetailsViewController: UIViewController {

    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var detailsTextView: UITextView!
    @IBOutlet private var detailsTextPlaceholder: UILabel!
    @IBOutlet private var dueDateTextField: UITextField!
    @IBOutlet private var addUpdateButton: UIButton!
    @IBOutlet private var expireLabel: UILabel!

    private var dueDatePicker: UIDatePicker!


    private var viewModel: TaskDetailsViewModel!
    private var onDone: ((_ modified: Bool)->())!

    
    class func initVC(service: TaskDBService, task: TaskModel?, onDone: @escaping ((_ modified: Bool)->()))->Self {
        let board = UIStoryboard(storyboard: .main)
        let detailsVC: Self = board.instantiateVC()
        detailsVC.viewModel = TaskDetailsViewModel(service: service, task: task)
        detailsVC.onDone = onDone
        return detailsVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        observeViewModel()
    }
    
    // Observe the ViewModel, received the changes happen.
    private func observeViewModel(){
        viewModel.onSuccessAlertShow = {
            AppUtility.showSuccessAlert(message: $0) {
                self.onDone?(true)
            }
        }
        
        viewModel.onFailAlertShow = {
            AppUtility.showFailAlert(message: $0)
        }
    }
    
    
    // Prepare the UI
    // Populate the UI by given task.
    private func setupUI(){
        self.title = "Task"
        
        dueDatePicker = UIDatePicker()
        dueDatePicker.datePickerMode = .dateAndTime
        dueDatePicker.backgroundColor = .white
        dueDatePicker.minimumDate = Date()
        dueDateTextField.inputView = dueDatePicker

        if #available(iOS 14, *) {
            dueDatePicker.preferredDatePickerStyle = .wheels
            dueDatePicker.sizeToFit()
        }
        
        
        if let task = viewModel.task {
            titleTextField.text = task.title
            detailsTextView.text = task.details
            addUpdateButton.setTitle("Update Task", for: .normal)
            
            dueDatePicker.date = task.dueDate
            textFieldDidEndEditing(dueDateTextField)
        }
        else {
            titleTextField.text = ""
            detailsTextView.text = ""
            addUpdateButton.setTitle("Create Task", for: .normal)
            expireLabel.text = ""
        }
        
        textViewDidChange(detailsTextView)
        
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 44)
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.tintColor = UIColor.white
        backButton.backgroundColor = .clear
        backButton.contentHorizontalAlignment = .left
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        if viewModel.task != nil {
            let deleteButton = UIButton(type: .system)
            deleteButton.frame = CGRect(x: 0, y: 0, width: 45, height: 44)
            deleteButton.backgroundColor = .clear
            deleteButton.contentHorizontalAlignment = .right
            deleteButton.imageView?.contentMode = .scaleAspectFit
            deleteButton.tintColor = .white
            deleteButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
            deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteButton)
        }
    }
    
    
    @IBAction func createAction() {
        validateAndCreateTask()
    }
    
    // Take confirmation before delete.
    @objc
    private func deleteAction() {
        guard let _ = viewModel.task else { return }
        
        AppUtility.showConfirmationAlert(message: "Are you sure, you want to delete the task?") { confirmed in
            if confirmed {
                self.viewModel.deleteTask()
            }
        }
    }
    
    @objc
    private func backAction() {
        onDone?(false)
    }
}



extension TaskDetailsViewController {
    
    // Validates on user given inputs.
    // Pass create or update command to ViewModel.
    private func validateAndCreateTask() {
        guard let title = titleTextField.text, title.isEmpty == false else {
            AppUtility.showWarningAlert(message: "Please enter the task title")
            return
        }
        
        guard title.count >= 3 else {
            AppUtility.showWarningAlert(message: "Title's length should equal or greater than 3")
            return
        }
        
        guard let details = detailsTextView.text, details.isEmpty == false else {
            AppUtility.showWarningAlert(message: "Please enter the task details")
            return
        }
        
        guard details.count >= 5 else {
            AppUtility.showWarningAlert(message: "Details's length should equal or greater than 10")
            return
        }
        
        guard let dateText = dueDateTextField.text, dateText.isEmpty == false else {
            AppUtility.showWarningAlert(message: "Please enter the due date")
            return
        }
        
        viewModel.createOrUpdateTask(title: title, detail: details, dueDate: dueDatePicker.date)
    }
}


extension TaskDetailsViewController: UITextViewDelegate {
    // Show/hide Details TextView's fake placeholder based on the text length.
    func textViewDidChange(_ textView: UITextView) {
        detailsTextPlaceholder.isHidden = textView.text.isEmpty == false
    }
}



extension TaskDetailsViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // Convert date object to date string and show it to due fields.
        // Show expiration based on the given due date.
        if textField == dueDateTextField {
            textField.text = dueDatePicker.date.toString(format: "yyyy-MM-dd HH:mm", local: true)
            
            if let expire = dueDatePicker.date.expireTime {
                expireLabel.text = "Expire in: " + expire
                expireLabel.textColor = .darkGray
            }
            else {
                expireLabel.text = "Expired"
                expireLabel.textColor = .systemRed
            }
        }
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField != dueDateTextField
    }
}
