//
//  CleanerListViewModel.swift
//  CarFit
//
//  Created by Kalpesh Talkar on 07/07/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

typealias CarWashResult = (_ carwashes: Array<CarwashVisit>?, _ error: String?) -> Void

class CleanerListViewModel {
    
    var carwashes = Array<CarwashVisit>()
    
    /// Get car washes scheduled by date.
    /// - Parameters:
    ///   - date: Date to get the scheduled car washes.
    ///   - completion: Result block called after fetching the car washes for the speified date.
    func getCarWashes(for date: Date, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        carwashes.removeAll()
        CarwashService.getAllCarwashes(for: date) { (data) in
            var errorMessage = data.message
            
            if let carwashes = data.data {
                // Filter carwashes by specified date
                self.carwashes = carwashes.filter({ (carwashVisit) -> Bool in
                    return date.isSameDay(date: carwashVisit.startTimeUtc)
                })
                if self.carwashes.isEmpty {
                    errorMessage = noCarwashes
                    
                    // Carwashes array is empty! Let's put some data if the date is today so that our app doesn't look blank when opened.
                    if date.isToday {
                        // Knowing that there are at least 4 carwashes in our json file.
                        if carwashes.count >= 4 {
                            for i in 0..<4 {
                                let today = Date()
                                let carwash = carwashes[i]
                                carwash.startTimeUtc.changeDayComponents(to: today)
                                carwash.endTimeUtc.changeDayComponents(to: today)
                                self.carwashes.append(carwash)
                            }
                        }
                        errorMessage = nil
                    }
                }
            }
            
            // Call the completion block
            completion(!self.carwashes.isEmpty, errorMessage)
        }
    }
    
    func totalCarwashes() -> Int {
        return carwashes.count
    }
    
    func carwash(for indexPath: IndexPath) -> CarwashVisit {
        return carwashes[indexPath.row]
    }
    
    func previousCarwash(indexPath: IndexPath) -> CarwashVisit? {
        if indexPath.row > 0 {
            return carwashes[indexPath.row - 1]
        }
        return nil
    }
    
}
