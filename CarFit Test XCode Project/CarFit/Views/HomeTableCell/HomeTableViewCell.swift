//
//  HomeTableViewCell.swift
//  Calendar
//
//  Test Project
//

import UIKit
import CoreLocation

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var tasks: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var timeRequired: UILabel!
    @IBOutlet weak var distance: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10.0
        self.statusView.layer.cornerRadius = self.status.frame.height / 2.0
        self.statusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func display(visit: CarwashVisit, previousVisit: CarwashVisit? = nil) {
        // Customer name
        customer.text = visit.getCustomerName()
        
        // Show visit state and color
        status.text = visit.visitState.rawValue
        switch visit.visitState {
        case .todo:
            statusView.backgroundColor = .todoOption
            break
            
        case .done:
            statusView.backgroundColor = .doneOption
            break
            
        case .inProgress:
            statusView.backgroundColor = .inProgressOption
            break
            
        case .rejected:
            statusView.backgroundColor = .rejectedOption
            break
        }
        
        // Tasks
        tasks.text = visit.getTaskDescription()
        
        // Time
        arrivalTime.text = visit.getTimeInfo()
        
        // Destination
        destination.text = visit.getCustomerAddress()
        
        // Time required
        timeRequired.text = visit.getTotalTime()
        
        // Distance
        var distanceFromPreviousVisit: Double = 0
        if let prevVisit = previousVisit {
            distanceFromPreviousVisit = visit.getLocation().distance(from: prevVisit.getLocation()) / 1000 // 1 Km = 1000 m
        }
        // Formatting distance that represents 1.0 as 1 and 1.234 as 1.2
        distance.text = String(format: "%.1g Km", distanceFromPreviousVisit)
    }

}
