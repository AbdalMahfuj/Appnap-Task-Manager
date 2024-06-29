//
//  CodableModel.swift
//  Task Manager
//
//  Created by Mahfuz on 27/6/24.
//


import Foundation


protocol CodableModel: Codable {
 
}


extension CodableModel {
    
    func toJSON()->Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            debugPrint("JSON Decode error: ", error.localizedDescription)
        }
        
        return nil
    }
    
   static func fromJSON(_ jsonData: Data?)->Self? {
        guard let jsonData = jsonData else { return nil }

        do {
           return try JSONDecoder().decode(Self.self, from: jsonData)
           
        } catch {
            debugPrint("JSON Decode error: ", error.localizedDescription)
        }
        return nil
    }
    
    
    static func arrayFromJSON(_ jsonData: Data?)->[Self]? {
         guard let jsonData = jsonData else { return nil }

         do {
            return try JSONDecoder().decode([Self].self, from: jsonData)
            
         } catch {
             debugPrint("JSON Decode error: ", error.localizedDescription)
         }
         return nil
     }
}

extension Array where Element : CodableModel {

    func toJSON()->Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            debugPrint("JSON Decode error: ", error.localizedDescription)
        }
        
        return nil
    }
}

