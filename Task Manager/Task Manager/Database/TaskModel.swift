//
//  ToDoModel.swift
//  Task Manager
//
//  Created by Mahfuz on 27/6/24.
//

import Foundation

class TaskModel: NSObject, CodableModel {
    
    let id: String
    let createdDateTimeStamp: Int

    private(set) var remoteId: String
    private(set) var title: String
    private(set) var details: String
    private(set) var updatedDateTimeStamp: Int
    private(set) var dueDateTimeStamp: Int
    private(set) var status: Int = ChangeStatus.synced.rawValue

   
    lazy var createdDate: Date = {
        return Date(timeIntervalSince1970: Double(createdDateTimeStamp))
    }()
    
    lazy var createdDateString: String = {
        let timeFormat = DateFormatter.is24Hour() ? "HH:mm" : "hh:mm a"
        return createdDate.toString(format: "dd MMM yyyy, " + timeFormat, local: true) ?? ""
    }()
    
    var updatedDate: Date {
        get {
            return Date(timeIntervalSince1970: Double(updatedDateTimeStamp))
        }
    }
    
    var updatedDateString: String {
        get {
            let timeFormat = DateFormatter.is24Hour() ? "HH:mm" : "hh:mm a"
            return updatedDate.toString(format: "dd MMM yyyy, " + timeFormat, local: true) ?? ""
        }
    }
    
    var dueDate: Date {
        get {
            return Date(timeIntervalSince1970: Double(dueDateTimeStamp))
        }
    }
    
    var dueDateString: String {
        get {
            let timeFormat = DateFormatter.is24Hour() ? "HH:mm" : "hh:mm a"
            return dueDate.toString(format: "dd MMM yyyy, " + timeFormat, local: true) ?? ""
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case remoteId = "_id"
        case title
        case details
        case createdDateTimeStamp
        case updatedDateTimeStamp
        case dueDateTimeStamp
        case status
    }
    
    init(id: String? = nil, title: String, details: String, dueDate: Date){
        self.id = id ?? UUID().uuidString
        self.remoteId = ""
        self.createdDateTimeStamp = Int(Date().timeIntervalSince1970)
        self.updatedDateTimeStamp = self.createdDateTimeStamp
        self.dueDateTimeStamp = Int(dueDate.timeIntervalSince1970)
        self.title = title
        self.details = details
        self.status = ChangeStatus.created.rawValue
    }
    
    
    init(managed: TaskMO) {
        self.id = managed.id
        self.remoteId = managed.remoteId
        self.title = managed.title
        self.details = managed.details
        self.createdDateTimeStamp = managed.createdDateTimeStamp.intValue
        self.updatedDateTimeStamp = managed.updatedDateTimeStamp.intValue
        self.dueDateTimeStamp = managed.dueDateTimeStamp.intValue
        self.status = managed.status.intValue
    }
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.remoteId = ""
        self.title = dictionary["title"] as? String ?? ""
        self.details = dictionary["details"] as? String ?? ""
        createdDateTimeStamp = dictionary["createdDateTimeStamp"] as? Int ?? 0
        updatedDateTimeStamp = dictionary["updatedDateTimeStamp"] as? Int ?? 0
        dueDateTimeStamp = dictionary["dueDateTimeStamp"] as? Int ?? 0
    }
    
    func update(title: String, details: String, dueDate: Date){
        self.title = title
        self.details = details
        self.dueDateTimeStamp = Int(dueDate.timeIntervalSince1970)
        self.updatedDateTimeStamp = Int(Date().timeIntervalSince1970)
        self.status = ChangeStatus.updated.rawValue
    }
    
    func updateRemoteId(_ id: String){
        remoteId = id
    }
    
    func updateStatus(_ status: ChangeStatus){
        self.status = status.rawValue
    }
    
    var toDictionary: [String: Any] {
        ["id": id,
         "title": title,
         "details": details,
         "createdDateTimeStamp": createdDateTimeStamp,
         "updatedDateTimeStamp": updatedDateTimeStamp,
         "dueDateTimeStamp": dueDateTimeStamp]
    }
}
