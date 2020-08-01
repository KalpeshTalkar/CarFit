//
//  CarwashTask.swift
//  CarFit
//
//  Created by Kalpesh Talkar on 05/07/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

struct CarwashTask: Codable {
    let taskId: String
    let title: String
    let isTemplate: Bool
    let timesInMinutes: Int
    let price: Double
    let paymentTypeId: String
}
