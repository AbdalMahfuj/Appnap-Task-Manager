//
//  StringExtension.swift
//  Task Manager
//
//  Created by Mahfuz on 27/6/24.
//

import Foundation

extension String {

    func toDate(_ format: String, utc: Bool)->Date? {
        let dateFormatter = DateFormatter()
        
        let local = Locale.init(identifier:"en_US_POSIX")
        dateFormatter.locale = local
        dateFormatter.dateFormat = format
        
        if utc {
            let zone = NSTimeZone(name: "UTC")! as TimeZone
            dateFormatter.timeZone = zone
        }
            
        return dateFormatter.date(from: self)
    }
}
