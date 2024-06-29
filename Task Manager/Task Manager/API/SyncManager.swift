//
//  SyncManager.swift
//  Task Manager
//
//  Created by Mahfuz on 28/6/24.
//

import Foundation


class SyncManager: NSObject {

    static let shared = SyncManager()
    
    private(set) var remoteIds = [String: String]()
    private(set) var isSyning: Bool = false
    private(set) var timer: Timer? = nil


    
    private override init() {
        super.init()
    }
    
    func appStarted() {
        remoteIds = UserDefaults.standard.dictionary(forKey: "remote_ids") as? [String: String] ??  [:]
    }
    
    
    // should call after user first time enter this app 
    
    func pullTasksFromRemote(onDone: @escaping (()->())) {
        APIManager.shared.getAllTasks { tasks in
            if let tasks, tasks.count > 0 {
                self.storeRemoteIds(tasks: tasks)
                DBManager.shared.insertTasks(tasks)
            }
            
            onDone()
        }
    }
    
    
    func taskCreated(_ task: TaskModel) {
        isSyning = true
        
        APIManager.shared.createTaskAtRemote(task: task) { success, remoteId in
            if success, let remoteId {
                task.updateRemoteId(remoteId)
                DBManager.shared.updateTaskAsSync(id: task.id)
                DBManager.shared.updateTaskRemoteId(id: task.id, remoteId: remoteId)
                self.storeRemoteId(localId: task.id, remoteId: remoteId)
            }
            
            self.isSyning = false
            self.startTimer()
        }
    }
    
    func taskUpdated(_ task: TaskModel) {
        guard let remoteId = remoteIds[task.id] else { return }
        
        isSyning = true

        APIManager.shared.updateTaskAtRemote(task: task, remoteId: remoteId) { success in
            if success {
               let updated = DBManager.shared.updateTaskAsSync(id: task.id)
                print("taskUpdated: ", updated)
            }
            
            self.isSyning = false
            self.startTimer()
        }
    }
    
    func taskDeleted(_ id: String) {
        guard let remoteId = remoteIds[id] else { return }
        
        isSyning = true

        APIManager.shared.deleteTaskFromRemote(remoteId: remoteId) { success in
            if success {
                DBManager.shared.deleteTask(id: id)
            }
            
            self.isSyning = false
            self.startTimer()
        }
    }
    
    private func storeRemoteIds(tasks: [TaskModel]){
        var storedIds: [String: String] = UserDefaults.standard.dictionary(forKey: "remote_ids") as? [String: String] ??  [:]
        
        tasks.forEach { task in
            storedIds[task.id] = task.remoteId
        }
        
        remoteIds = storedIds
        UserDefaults.standard.setValue(storedIds, forKey: "remote_ids")
        UserDefaults.standard.synchronize()
    }
    
    private func storeRemoteId(localId: String, remoteId: String){
        var storedIds: [String: String] = UserDefaults.standard.dictionary(forKey: "remote_ids") as? [String: String] ??  [:]
       
        if storedIds[localId] == nil {
            storedIds[localId] = remoteId
            remoteIds = storedIds
            
            UserDefaults.standard.setValue(storedIds, forKey: "remote_ids")
            UserDefaults.standard.synchronize()
        }
    }
}


extension SyncManager {
    
    private func startSyncingIfPossible(){
        guard isSyning == false else {
            startTimer()
            return
        }
        
        guard let task = DBManager.shared.getLastNotSyncTask() else { return }
                
        switch ChangeStatus(rawValue: task.changeStatus) {
        case .created:
            taskCreated(task)
            
        case .updated:
            taskUpdated(task)
            
        case .deleted:
            taskDeleted(task.id)
            
        default: break
        }
    }
    
    private func startTimer(){
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: false)
    }
    
    private func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    @objc
    private func timerFired(){
        startSyncingIfPossible()
    }
}
