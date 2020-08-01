//
//  CarwashService.swift
//  CarFit
//
//  Created by Kalpesh Talkar on 05/07/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

typealias CarFitVisitsResult = (APIResult<Array<CarwashVisit>>) -> Void

class CarwashService {
    
    static func getAllCarwashes(for date: Date, result: @escaping CarFitVisitsResult) {
        // Get data on backgroound queue so that we don't block the UI
        DispatchQueue.global(qos: .background).async {
            var error: String? = nil
            var data: APIResult<Array<CarwashVisit>>? = nil
            
            // Read the data from the json file
            let path = Bundle.main.path(forResource: jsonFileName, ofType: jsonFileExtension)
            if path != nil {
                data = JSONObject.from(path: path!, type: APIResult<Array<CarwashVisit>>.self, dateDecodingStartegy: .formatted(DateFormatter.iso), keyDecodingStartegy: .convertFromSnakeCase)
            } else {
                error = jsonParsingError
            }
            
            // Post result on main queue
            DispatchQueue.main.async {
                if data != nil {
                    result(data!)
                } else {
                    result(APIResult(success: false, data: nil, message: error))
                }
            }
        }
    }
    
}
