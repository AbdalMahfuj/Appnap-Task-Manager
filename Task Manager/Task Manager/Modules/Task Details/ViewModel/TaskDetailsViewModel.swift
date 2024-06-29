//
//  TaskDetailsViewModel.swift
//  Task Manager
//
//  Created by Mahfuz on 27/6/24.
//

import Foundation

class TaskDetailsViewModel {
    
    private let dbService: TaskDBService
    
    private(set) var task: TaskModel? = nil
    
    
    var onRefresh: (()->())?
    var onSuccessAlertShow: ((String)->())?
    var onFailAlertShow: ((String)->())?
    
    
    init(service: TaskDBService, task: TaskModel?){
        self.dbService = service
        self.task = task
    }
    
    
    // Insert or update the task based on the task existence.
    // Update: Commit the changes to the local DB. And Let know the Sync Manager about the changes.
    // Insert: Insert the task to the local DB. And Let know the Sync Manager about the creation.
    func createOrUpdateTask(title: String, detail: String, dueDate: Date){
        if let task {
            task.update(title: title, details: detail, dueDate: dueDate)
            
            let updated = dbService.updateTask(task)
            
            if updated {
                self.onSuccessAlertShow?("The task has been updated successfully.")
                SyncManager.shared.taskUpdated(task)
            }
            else {
                self.onFailAlertShow?("Failed to update the task.")
            }
        }
        else {
            let task = TaskModel(title: title, details: detail, dueDate: dueDate)
            
            let inserted = dbService.insertTask(task)
            
            if inserted {
                self.onSuccessAlertShow?("A task has been created successfully.")
                SyncManager.shared.taskCreated(task)
            }
            else {
                self.onFailAlertShow?("Failed to create task.")
            }
        }
    }
    
    
    // Based on the task existence, softly delete from Local DB,
    // Also let know the Sync Manager.
    func deleteTask() {
        guard let task else { return }
        
        let deleted = dbService.softDeleteTask(id: task.id)
        
        if deleted {
            self.onSuccessAlertShow?("The task has been deleted successfully.")
            SyncManager.shared.taskDeleted(task.id)
        }
        else {
            self.onFailAlertShow?("Failed to delete the task.")
        }
    }
}
