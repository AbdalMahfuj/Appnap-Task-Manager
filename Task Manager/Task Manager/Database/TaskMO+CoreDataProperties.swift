//
//  TaskMO+CoreDataProperties.swift
//  Task Manager
//
//  Created by Mahfuz on 28/6/24.
//
//

import Foundation
import CoreData


extension TaskMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskMO> {
        return NSFetchRequest<TaskMO>(entityName: "TaskMO")
    }

    @NSManaged public var id: String
    @NSManaged public var remoteId: String
    @NSManaged public var title: String
    @NSManaged public var details: String
    @NSManaged public var createdDateTimeStamp: NSNumber
    @NSManaged public var updatedDateTimeStamp: NSNumber
    @NSManaged public var dueDateTimeStamp: NSNumber
    @NSManaged public var changeStatus: NSNumber
    @NSManaged public var status: NSNumber

    
    
    func update(entity: TaskModel) {
        id = entity.id
        remoteId = entity.remoteId
        title = entity.title
        details = entity.details
        createdDateTimeStamp = entity.createdDateTimeStamp as NSNumber
        updatedDateTimeStamp = entity.updatedDateTimeStamp as NSNumber
        dueDateTimeStamp = entity.dueDateTimeStamp as NSNumber
        changeStatus = entity.changeStatus as NSNumber
        status = entity.status as NSNumber
    }
}

extension TaskMO : Identifiable {

}
