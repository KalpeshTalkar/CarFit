//
//  CarFitVisitExtension.swift
//  CarFit
//
//  Created by Kalpesh Talkar on 09/07/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import CoreLocation

extension CarwashVisit {
    
    func getCustomerName() -> String {
        return "\(houseOwnerFirstName) \(houseOwnerLastName)"
    }
    
    func getTimeInfo() -> String {
        var timeInfo = startTimeUtc.time
        if let expectedTime = self.expectedTime {
            timeInfo += " - \(expectedTime)"
        }
        return timeInfo
    }
    
    func getCustomerAddress() -> String {
        return "\(houseOwnerAddress) \(houseOwnerZip) \(houseOwnerCity)"
    }
    
    func getTaskDescription() -> String {
        var desc = ""
        
        // Combine the title of all tasks separated by comma
        tasks.forEach { (task) in
            desc += "\(task.title), "
        }
        
        // Our desc contains a coma and space at the end.
        // Remove extra space at the end
        desc = desc.trimmingCharacters(in: .whitespacesAndNewlines)
        // Drop the coma at the end
        desc = "\(desc.dropLast())"
        
        return desc
    }
    
    func getTotalTime() -> String {
        var totalTime = 0
        tasks.forEach { (task) in
            totalTime += task.timesInMinutes
        }
        return "\(totalTime) min"
    }
    
    func getLocation() -> CLLocation {
        return CLLocation(latitude: houseOwnerLatitude, longitude: houseOwnerLongitude)
    }
    
}
