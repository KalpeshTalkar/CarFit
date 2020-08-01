//
//  DateUtils.swift
//
//  Created by Kalpesh Talkar.
//  Copyright © 2020 Kalpesh Talkar. All rights reserved.
//

import Foundation

extension Date {
    
    // MARK: - Formatted dates
    
    var stringValue: String {
        get {
            return DateFormatter.default.string(from: self)
        }
    }
    
    var monthAndYear: String {
        get {
            return DateFormatter.monthAndYear.string(from: self)
        }
    }
    
    var dayOfWeek: String {
        get {
            return DateFormatter.dayOfWeek.string(from: self)
        }
    }
    
    var day: String {
        get {
            return DateFormatter.day.string(from: self)
        }
    }
    
    var dateInYMD: String {
        get {
            return DateFormatter.ymd.string(from: self)
        }
    }
    
    var time: String {
        get {
            return DateFormatter.hhmm.string(from: self)
        }
    }
    
    // MARK: - Date comparisions
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isInThisMonth: Bool {
        return isInSameMonth(date: Date())
    }
    
    /// Compares (excluding the time component) self with the date and returns if they are in the same month of the same year.
    /// - Parameter date: Date to be compared with.
    func isInSameMonth(date: Date) -> Bool {
        let calendar = Calendar.current
        let components:Set<Calendar.Component> = [.month, .year]
        
        // Get month and year components
        let selfComponents = calendar.dateComponents(components, from: self)
        let todayComponents = calendar.dateComponents(components, from: date)
        
        // Compare self's month and year components with the today's date.
        return selfComponents.month == todayComponents.month &&
            selfComponents.year == todayComponents.year
    }
    
    
    /// Compares (excluding the time component) self with the date and returns if they are same.
    /// - Parameter date: Date to be compared with.
    func isSameDay(date: Date) -> Bool {
        let calendar = Calendar.current
        let components:Set<Calendar.Component> = [.day, .month, .year]
        
        // Get day, month, and year components
        let selfComponents = calendar.dateComponents(components, from: self)
        let otherComponents = calendar.dateComponents(components, from: date)
        
        // Compare self's day, month, and year components with the specified date.
        return selfComponents.day == otherComponents.day &&
            selfComponents.month == otherComponents.month &&
            selfComponents.year == otherComponents.year
    }

    
    func changeDayComponents(to date: Date) {
        let calendar = Calendar.current
        let components:Set<Calendar.Component> = [.day, .month, .year, .hour, .minute, .second]
        
        // Get day, month, and year components
        var selfComponents = calendar.dateComponents(components, from: self)
        let otherComponents = calendar.dateComponents(components, from: date)
        
        selfComponents.day = otherComponents.day
        selfComponents.month = otherComponents.month
        selfComponents.year = otherComponents.year
    }
    
}
