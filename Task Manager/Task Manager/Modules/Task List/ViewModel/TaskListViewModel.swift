//
//  TaskListViewModel.swift
//  Task Manager
//
//  Created by Mahfuz on 27/6/24.
//

import Foundation

class TaskListViewModel {
    
    let dbService: TaskDBService

    private(set) var items: [TaskModel] = []
    
    var onRefresh: (()->())?
    var onAlertShow: ((String, String)->())?
    var onLoaderShow: ((Bool)->())?

    
    init(service: TaskDBService){
        self.dbService = service
    }
    
    
    // Fetched the not deleted Tasks from Local DB.
    // Before that, fetch remote tasks. Will appicable only once in app's full life cycle.
    func fetchTasks() {
        let remoteFetched = UserDefaults.standard.bool(forKey: "remote_fetch_all")
        
        if remoteFetched {
            items = dbService.getNotDeletedTasks()
            sort()
        }
        else {
            onLoaderShow?(true)
            SyncManager.shared.pullTasksFromRemote {
                UserDefaults.standard.setValue(true, forKey: "remote_fetch_all")
                UserDefaults.standard.synchronize()
                self.fetchTasks()
                self.onLoaderShow?(false)
            }
        }
    }
    
    
    // Sort the tasks according to the due date as ascending.
    private func sort(){
        items.sort{ $0.dueDate < $1.dueDate }
        onRefresh?()
    }
    
    
    // After checking the index of array, softly delete item from DB.
    // remove the item from the array.
    // Let know the Sync manager about that deletion.
    func deleteTask(index: Int) {
        guard index < items.count else { return }
        
        let task = items[index]
        let deleted = dbService.softDeleteTask(id: task.id)
        
        if deleted {
            self.onAlertShow?("Successful", "The task has been deletd successfully.")
            self.items = self.items.filter { $0.id != task.id }
            self.sort()
            SyncManager.shared.taskDeleted(task.id)
        }
        else {
            self.onAlertShow?("Failed", "Failed to delete the task.")
        }
    }
}
