//
//  APIURL.swift
//  Labaid Cancer
//
//  Created by Mahfuz on 9/6/24.
//

import Foundation


struct APIUrl {

    static func createURL()->String             { baseUrl + createPath }
    static func getAllURL()->String             { baseUrl + getAllPath }
    static func getURL(id: String)->String      { baseUrl + getPath + id }
    static func updateURL(id: String)->String   { baseUrl + updatePath + id }
    static func deleteURL(id: String)->String   { baseUrl + deletePath + id }
    
}



extension APIUrl {
    
    private static let baseUrl      = "https://crudcrud.com/"

    private static let createPath   = "api/b0c829c450c44e2492eff863487b101d/mahfuz_tasks"
    private static let getAllPath   = "api/b0c829c450c44e2492eff863487b101d/mahfuz_tasks"
    private static let getPath      = "api/b0c829c450c44e2492eff863487b101d/mahfuz_tasks/"
    private static let updatePath   = "api/b0c829c450c44e2492eff863487b101d/mahfuz_tasks/"
    private static let deletePath   = "api/b0c829c450c44e2492eff863487b101d/mahfuz_tasks/"
}
