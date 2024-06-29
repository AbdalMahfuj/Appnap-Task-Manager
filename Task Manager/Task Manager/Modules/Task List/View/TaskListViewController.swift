//
//  TaskListViewController.swift
//  Task Manager
//
//  Created by Mahfuz on 27/6/24.
//

import UIKit

class TaskListViewController: UIViewController {

    @IBOutlet private var todoListTableView: UITableView!
    @IBOutlet private var noTaskView: UIView!
    
    private var createButton: UIButton!
    
    private var viewModel: TaskListViewModel!

    
    class func initVC()->Self {
        let board = UIStoryboard(storyboard: .main)
        let homeVC: Self = board.instantiateVC()
        let dbService = DBManager.shared
        homeVC.viewModel = TaskListViewModel(service: dbService)
        return homeVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        observeViewModel()
        viewModel.fetchTasks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        todoListTableView.reloadData()
    }
    
    // Prepare the UI
    // Populate the UI by given task.
    private func setupUI(){
        self.title = "Home"
        todoListTableView.registerCellNib(TaskListItemTableCell.self)
                 
        createButton = UIButton(type: .system)
        createButton.frame = CGRect(x: 0, y: 0, width: 45, height: 44)
        createButton.backgroundColor = .clear
        createButton.contentHorizontalAlignment = .right
        createButton.imageView?.contentMode = .scaleAspectFit
        createButton.tintColor = .white
        createButton.setImage(UIImage(systemName: "plus"), for: .normal)
        createButton.addTarget(self, action: #selector(createTaskAction), for: .touchUpInside)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createButton)
    }
    
    // Observe the viewModel if any changes, reload the List on every call
    private func observeViewModel(){
        viewModel.onLoaderShow = { show in
            if show {
                AppUtility.shared.showLoader()
            }
            else {
                AppUtility.shared.hideLoader()
            }
        }
        
        viewModel.onRefresh = {
            self.reloadList()
        }
        
        viewModel.onAlertShow = { title, msg in
            AppUtility.showOkAlert(title, message: msg)
        }
    }
    
    @IBAction func createTaskAction(){
        gotoDetails(index: nil)
    }
    
    private func reloadList() {
        todoListTableView.reloadData()
        todoListTableView.isHidden = viewModel.items.isEmpty
        createButton.isHidden = viewModel.items.isEmpty
        noTaskView.isHidden = viewModel.items.isEmpty == false
    }

    
    // Redirect to the detail of the specific task
    private func gotoDetails(index: Int?){
        let task = index == nil ? nil : viewModel.items[index!]
        
        let detailsVC = TaskDetailsViewController.initVC(service: viewModel.dbService, task: task) { createdOrUpdated in
            self.viewModel.fetchTasks()
            self.navigationController?.popViewController(animated: true)
        }
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    // Take confirmation before delete
    private func showDeleteConfirmation(index: Int){
        let task = viewModel.items[index]
        AppUtility.showConfirmationAlert(message: "Are you sure, you want to delete the task '\(task.title)'?") { confirmed in
            
            if confirmed {
                self.viewModel.deleteTask(index: index)
            }
            else {
                self.reloadList()
            }
        }
    }
}



extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TaskListItemTableCell = tableView.dequeueCell()!
        cell.config(toDo: viewModel.items[indexPath.row])
        return cell
    }
    
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        gotoDetails(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Delete") {  _, _, completion in
            self.showDeleteConfirmation(index: indexPath.row)
            completion(false)
        }
        
        action.backgroundColor = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [action])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}


