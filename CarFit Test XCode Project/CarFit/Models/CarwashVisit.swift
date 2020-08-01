//
//  CarwashVisit.swift
//  CarFit
//
//  Created by Kalpesh Talkar on 05/07/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

enum State: String, Codable {
    case todo = "ToDo"
    case done = "Done"
    case inProgress = "InProgress"
    case rejected = "Rejected"
}

struct CarwashVisit: Codable {
    let visitId: String
    let homeBobEmployeeId: String
    let houseOwnerId: String
    let isBlocked: Bool
    let startTimeUtc: Date
    let endTimeUtc: Date
    let title: String
    let isReviewed: Bool
    let isFirstVisit: Bool
    let isManual: Bool
    let visitTimeUsed: Int
    let houseOwnerFirstName: String
    let houseOwnerLastName: String
    let houseOwnerMobilePhone: String
    let houseOwnerAddress: String
    let houseOwnerZip: String
    let houseOwnerCity: String
    let houseOwnerLatitude: Double
    let houseOwnerLongitude: Double
    let isSubscriber: Bool
    let professional: String?
    let visitState: State
    let stateOrder: Int
    let expectedTime: String?
    let tasks: Array<CarwashTask>
}
