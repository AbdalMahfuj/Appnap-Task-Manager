//
//  APIManager.swift
//  Task Manager
//
//  Created by Mahfuz on 28/6/24.
//
//

import Foundation

typealias HttpStatus = Int


enum ResponseStatus : Int, Codable {
    case valid = 200
    case error = 1
    case invalidToken = 401
}

enum RequestMethod : String, CustomStringConvertible {
    case get
    case post
    case put
    case delete

    var description: String {
        self.rawValue.uppercased()
    }
}

enum RequestContent : String, CustomStringConvertible {
    case json
    case formURLEncoded
    case formData

    var description: String {
        self.rawValue.uppercased()
    }
}


class APIManager: NSObject {
    
    static let shared = APIManager()
    private let session : URLSession
    
    
    private override init() {
        session = URLSession(configuration: URLSessionConfiguration.default)
        super.init()
    }
    
    func getAllTasks(onDone: @escaping (([TaskModel]?)->())) {
        request(APIUrl.getAllURL(), method: .get) { data, status in
            if let data, status == 200 {
                let tasks = TaskModel.arrayFromJSON(data)
                onDone(tasks)
            }
            else {
                onDone(nil)
            }
        }
    }
    
    func createTaskAtRemote(task: TaskModel, onComplete: @escaping ((_ success: Bool, _ remoteId: String?)->()) ) {
        request(APIUrl.createURL(), method: .post, parameters: task.toDictionary) { data, status in
            if let data, status == 201, let json = self.jsonFrom(data: data) as? [String: Any], let remoteId = json["_id"] as? String {
                print(json)
                onComplete(true, remoteId)
            }
            else {
                onComplete(false, nil)
            }
        }
    }
    
    func updateTaskAtRemote(task: TaskModel, remoteId: String, onComplete: @escaping ((_ success: Bool)->()) ) {
        request(APIUrl.updateURL(id: remoteId), method: .put, parameters: task.toDictionary) { _, status in
            onComplete(status == 200)
        }
    }
    
    func deleteTaskFromRemote(remoteId: String, onComplete: @escaping ((_ success: Bool)->()) ) {
        request(APIUrl.deleteURL(id: remoteId), method: .delete) { _, status in
            onComplete(status == 200)
        }
    }
   
}


extension APIManager {
    private func request(_ urlString: String,
                         method: RequestMethod,
                         parameters: [String: Any] = [:],
                         httpBody: Data? = nil,
                         headers: [String: String] = [:],
                         contentType: RequestContent = .json,
                         timeOut: Double = 20,
                         completion: @escaping((Data?, HttpStatus?)->())) {
        
        print("\nparameters: \(parameters)\n")
        guard var url = URL(string: urlString) else {
            completion(nil, -1)
            return
        }
        
        
        var requestData: Data?

        if (method == .get || contentType == .formURLEncoded), parameters.count > 0 {
            guard var components = URLComponents(string: urlString) else {
                completion(nil, -1)
                return
            }
            
            components.queryItems = parameters.compactMap { parm -> URLQueryItem? in
                if let value = parm.value as? String {
                    return URLQueryItem(name: parm.key, value: value)
                }
                else {
                    return URLQueryItem(name: parm.key, value: (parm.value as AnyObject) .description)
                }
            }
            
            guard let _url = components.url else {
                completion(nil, -1)
                return
            }
            
            
            if method == .get  {
                url = _url
            }
            else {
                requestData = components.query?.data(using: .utf8)
            }
        }
        else if contentType == .formData, parameters.count > 0 {
            var infos = [String]()
            
            for(key, value) in parameters {
                infos.append(key + "=\(value)")
            }
            
            requestData = infos.map { String($0) }.joined(separator: "&").data(using: .utf8)
        }
        else if let httpBody {
            requestData = httpBody
        }
        
        
              
        
        var request = URLRequest(url: url)
        
        request.timeoutInterval = timeOut
        request.httpMethod = method.description
        request.addValue(contentType == .formURLEncoded ? "application/x-www-form-urlencoded" : "application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(contentType == .formURLEncoded ? "application/x-www-form-urlencoded" : "application/json", forHTTPHeaderField: "Content-Type")

        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
                
        if let requestData {
            request.httpBody = requestData
        }
        else if method != .get {
            requestData = jsonDataFrom(dic: parameters)
            request.httpBody = requestData
        }
        
        logRequest(url: request.url!, headers: headers, jsonData: requestData)
        
        let task = session.dataTask(with: request) { data, response, error in
            self.logResponse(data: data)
            
            DispatchQueue.main.async {
                completion(data, (response as? HTTPURLResponse)?.statusCode)
            }
        }
        
        task.resume()
    }
    
    
    private func jsonDataFrom(dic: Any)->Data? {
        try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
    }
    
    private func jsonFrom(data: Data)->Any? {
        try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
    }
    
    private func logRequest(url: URL, headers: [String: String],  jsonData: Data?){
        #if DEBUG
        print("\nREQUEST ::>>>\n")
        print("URL: ", url)
        
        print("Headers: ", headers)
        
        if let jsonData = jsonData, let reqJson = jsonFrom(data: jsonData) {
            print("\nBody : \n", reqJson)
        }
        #endif
    }
    
    
    private func logResponse(data: Data?) {
        #if DEBUG
        print("\n\n****   RESPONSE   ****\n")
        
        if let data = data {
            if let json = self.jsonFrom(data: data) {
                print("JSON : \n", json)
            }
            else if let responseString = String.init(data: data, encoding: .utf8) {
                print("String : \n", responseString)
            }
            else {
                print("Non formatted data")
            }
        }
        else {
            print("No Data Found")
        }
        
        print("\n-----  =======   -----\n\n")
        #endif
    }
}
