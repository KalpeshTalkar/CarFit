//
//  CalendarViewModel.swift
//  CarFit
//
//  Created by Kalpesh Talkar on 07/07/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

class CalendarViewModel {
    
    let calendar = Calendar.current
    var currentMonth: Date!   // Dates will be initialised in the init() method
    var selectedDate: Date!   // Dates will be initialised in the init() method
    
    var daysInCurrentMonth = Array<Date>()
    
    init() {
        // Get instance of today. By default we keep the current month and selected date to today.
        selectedDate = Date()
        
        // For month, we set the day component to 1 so that we always get 1st day of every month.
        // Doing this helps us changing the month to previous or next by ading/subttacting the month component by 1.
        // Also, when we fetch all days for this month, we get exact days of the same month.
        // If we don't force set the day = 1 in the components, fetching the days in the current month may give days from the next month also.
        var dateComponentsForCurrentMonth = calendar.dateComponents([.day, .month, .year], from: selectedDate)
        dateComponentsForCurrentMonth.day = 1
        currentMonth = calendar.date(from: dateComponentsForCurrentMonth) ?? selectedDate
        
        // Get dates for current month
        getDaysForCurrentMonth()
    }
    
    func previousMonth() {
        changeMonth(by: -1)
    }
    
    func nextMonth() {
        changeMonth(by: 1)
    }
    
    private func changeMonth(by value: Int) {
        currentMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) ?? currentMonth
        // Get days for current month
        getDaysForCurrentMonth()
    }
    
    func getCurrentMonthAndYear() -> String {
        return currentMonth.monthAndYear
    }
    
    func getDaysForCurrentMonth() {
        // Clear all the dates
        daysInCurrentMonth.removeAll()
        
        // Get total days in the current month
        if let range = calendar.range(of: .day, in: .month, for: currentMonth) {
            // Add all the dates to the array
            for i in 0..<range.count {
                if let date = calendar.date(byAdding: .day, value: i, to: currentMonth) {
                    daysInCurrentMonth.append(date)
                }
            }
        }
    }
    
    func numberOfDaysInCurrentMonth() -> Int {
        return daysInCurrentMonth.count
    }
    
    func date(for indexPath: IndexPath) -> Date {
        return daysInCurrentMonth[indexPath.item]
    }
    
    func indexPathForSelectedDate() -> IndexPath? {
        let results = daysInCurrentMonth.compactMap { (date) -> IndexPath? in
            if date.isSameDay(date: selectedDate) {
                if let index = daysInCurrentMonth.firstIndex(of: date) {
                    return IndexPath(item: index, section: 0)
                }
            }
            return nil
        }
        return results.first
    }
    
    func select(date: Date) {
        selectedDate = date
    }
    
    func isSelected(date: Date) -> Bool {
        return selectedDate.isSameDay(date: date)
    }
    
}
