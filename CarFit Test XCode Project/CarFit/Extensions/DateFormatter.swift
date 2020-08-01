//
//  DateFormatter.swift
//
//  Created by Kalpesh Talkar.
//  Copyright © 2020 Kalpesh Talkar. All rights reserved.
//

import Foundation

fileprivate let defaultDateFormat = "d MMM yyyy EEE h:mm a"
fileprivate let isoDateFormat = "yyyy-MM-dd'T'HH:mm:ss"
fileprivate let ymdDateFormat = "yyyy-MM-dd"
fileprivate let monthYearDateFormat = "MMM yyyy"
fileprivate let dayDateFormat = "d"
fileprivate let dayOfWeekDateFormat = "EEE"
fileprivate let hhmmDateFormat = "hh:mm"

extension DateFormatter {
    
    convenience public init(with format: String) {
        self.init()
        dateFormat = format
    }
    
    static var `default`: DateFormatter {
        return DateFormatter(with: defaultDateFormat)
    }
    
    static var iso: DateFormatter {
        return DateFormatter(with: isoDateFormat)
    }
    
    static var ymd: DateFormatter {
        return DateFormatter(with: ymdDateFormat)
    }
    
    static var monthAndYear: DateFormatter {
        return DateFormatter(with: monthYearDateFormat)
    }
    
    static var day: DateFormatter {
        return DateFormatter(with: dayDateFormat)
    }
    
    static var dayOfWeek: DateFormatter {
        return DateFormatter(with: dayOfWeekDateFormat)
    }
    
    static var hhmm: DateFormatter {
        return DateFormatter(with: hhmmDateFormat)
    }
    
}
