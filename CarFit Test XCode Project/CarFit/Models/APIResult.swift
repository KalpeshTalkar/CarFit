//
//  APIResult.swift
//
//  Created by Kalpesh Talkar.
//  Copyright © 2020 Kalpesh Talkar. All rights reserved.
//

import Foundation

/// APIResult is a blueprint/structure for our response from API.
/// Modify this strcuture as per the API response strcuture.
struct APIResult<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let message: String?
}
