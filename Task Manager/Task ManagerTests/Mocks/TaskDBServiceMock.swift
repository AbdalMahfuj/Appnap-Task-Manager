//
//  TaskDBServiceMock.swift
//  Task ManagerTests
//
//  Created by Mahfuz on 28/6/24.
//

import UIKit

class TaskDBServiceMock: TaskDBService {
   
    
    var mockObjectFile: String? {
        didSet {
            modelsFromFile(mockObjectFile)
        }
    }
    
    private(set) var tasks = [TaskModel]()
    
    
    init() {
    }
    
    func insertTask(_ task: TaskModel)->Bool {
        tasks.append(task)
        return true
    }
    
    func getTasks()->[TaskModel] {
        return tasks
    }
    
    func getTask(by id: String)->TaskModel? {
        return tasks.first { $0.id == id }
    }
    
    func updateTask(_ toDo: TaskModel)->Bool {
        if let firstObjc = tasks.first(where: { $0.id == toDo.id }) {
            firstObjc.update(title: toDo.title, details: toDo.details, dueDate: toDo.dueDate)
            return true
        }
        else {
            return false
        }
    }
    
    func deleteTask(id: String)->Bool {
        if let firstObjc = tasks.first(where: { $0.id == id }) {
            tasks = tasks.filter { $0.id != firstObjc.id }
            return true
        }
        else {
            return false
        }
    }
    
    func getNotDeletedTasks() -> [TaskModel] {
        tasks.filter { $0.status != ChangeStatus.deleted.rawValue }
    }
    
    func getLastNotSyncTask() -> TaskModel? {
        let objects = tasks.sorted { $0.updatedDateTimeStamp < $1.updatedDateTimeStamp }
        
        if let firstObjc = objects.first(where: { $0.status != ChangeStatus.synced.rawValue }) {
            return firstObjc
        }
        else {
            return nil
        }
    }
    
    func updateTaskAsSync(id: String) -> Bool {
        if let firstObjc = tasks.first(where: { $0.id == id }) {
            firstObjc.updateStatus(.synced)
            return true
        }
        else {
            return false
        }
    }
    
    func softDeleteTask(id: String) -> Bool {
        if let firstObjc = tasks.first(where: { $0.id == id }) {
            firstObjc.updateStatus(.deleted)
            return true
        }
        else {
            return false
        }
    }
    
    
    private func modelsFromFile(_ file: String?){
        guard let file, file.count > 0, let url = Bundle.main.url(forResource: file, withExtension: "json") else { return }
        
        guard let data = try? Data(contentsOf: url)else { return }
        
        let jsonArray = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]]
        
        jsonArray?.forEach({ dic in
            tasks.append(TaskModel(dictionary: dic))
        })
    }
}
