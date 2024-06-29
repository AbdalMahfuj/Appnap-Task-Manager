//
//  Mapper.swift
//  Task Manager
//
//  Created by Mahfuz on 27/6/24.
//

import UIKit
import CoreData

extension NSManagedObject {
    
   public func updateWith(entity: NSObject) {
        if entity is TaskModel {
            let eObj = entity as! TaskModel
            let obj = self as! TaskMO
            obj.update(entity: eObj)
            return
        }
    }
    
    public func toEntity()->NSObject! {
        if self is TaskMO {
            let obj = self as! TaskMO
            let eObj = TaskModel(managed: obj)
            return eObj
        }
       
        return nil
    }
}

