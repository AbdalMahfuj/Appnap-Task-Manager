//
//  DateExtension.swift
//  Task Manager
//
//  Created by Mahfuz on 27/6/24.
//

import Foundation

extension DateFormatter {
    
   static func is24Hour() -> Bool {
        let dateFormat = Self.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        return dateFormat.firstIndex(of: "a") == nil
    }
}



extension Date {
    
    func toString(format: String, local: Bool)->String? {
        let dateFormatter = DateFormatter()
            
        dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        dateFormatter.dateFormat = format
        
        if !local {
            let zone = NSTimeZone(name: "UTC")! as TimeZone
            dateFormatter.timeZone = zone
        }
        
        return dateFormatter.string(from: self)
    }
    
    func toShortTimeString(local: Bool)->String? {
        var dateString : String!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        
        if !local {
            let zone = NSTimeZone(name: "UTC")! as TimeZone
            
            dateFormatter.timeZone = zone
        }
        
        dateString = dateFormatter.string(from: self as Date)
        
        
        let times = dateString.components(separatedBy: ":")
        
        if times.count != 2 {
            return nil
        }
        
        let mins = times[1]
        
        if mins.count > 2 {
            return dateString
        }
        
        var hour = times[0]
        let hourInt = Int(hour)!
        var ampm = "AM"
        
        if hourInt >= 12 {
            ampm = "PM"
        }
        
        if hourInt > 12{
            hour = "\(hourInt % 12)"
        }
        
        return hour + ":" + mins + " " + ampm
    }
    
    func to24ShortTimeString(local: Bool)->String? {
        var dateString : String!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.sss"
        
        if !local {
            let zone = NSTimeZone(name: "UTC")! as TimeZone
            dateFormatter.timeZone = zone
        }
        
        dateString = dateFormatter.string(from: self as Date)
        print("time " + dateString)
        
        let timesSlots = dateString.components(separatedBy: " ")
        
        if timesSlots.count == 1 { return dateString }
        
        dateString = timesSlots[0]
        let ampm = timesSlots[1].uppercased()
        
        if ampm == "AM" {
            return dateString
        }
        else {
            let times = dateString.components(separatedBy: ":")

            if times.isEmpty { return nil }

            var hourInt = Int(times[0]) ?? 0
            
            if hourInt == 12 {
                return dateString
            }
            
            hourInt += 12
            
            if times.count < 3 { return nil }

            return "\(hourInt):\(times[1]):\(times[2])"
        }
    }
    
    var expireTime: String? {
        let now = Date()
        
        if self > now {
           var duration = Int(self.timeIntervalSince(now))
            
            var texts = [String]()
            
            if duration > 86400 {
                let day = duration/86400
                duration = duration%86400
                texts.append(day.description + " day" + "\(day>1 ? "s" : "")")
            }
            
            if duration > 3600 {
                let hour = duration/3600
                duration = duration%3600
                texts.append(hour.description + " hour" + "\(hour>1 ? "s" : "")")
            }
            
            if duration > 60 {
                let min = duration/60
                duration = duration%60
                texts.append(min.description + " min" + "\(min>1 ? "s" : "")")
            }
            
            if texts.isEmpty {
                return duration.description + " sec" + "\(duration>1 ? "s" : "")"
            }
            else {
                return texts.joined(separator: ", ")
            }
        }
        else {
            return nil
        }
    }
}
