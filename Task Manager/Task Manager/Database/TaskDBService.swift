//
//  TaskDBService.swift
//  Task Manager
//
//  Created by Mahfuz on 28/6/24.
//

import Foundation


protocol TaskDBService {
    
    func insertTask(_ task: TaskModel)->Bool
    
    func getTasks()->[TaskModel]
    
    func getNotDeletedTasks()->[TaskModel]
    
    func getTask(by id: String)->TaskModel?
    
    func getLastNotSyncTask()->TaskModel? 
    
    func updateTask(_ task: TaskModel)->Bool
    
    func updateTaskAsSync(id: String)->Bool
    
    func softDeleteTask(id: String)->Bool
    
    func deleteTask(id: String)->Bool
    
}

