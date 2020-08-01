//
//  JSON Utils.swift
//
//  Created by Kalpesh Talkar.
//  Copyright © 2020 Kalpesh Talkar. All rights reserved.
//

import Foundation

// Type definitions
typealias JSONObject = Dictionary<String, Any>
typealias JSONArray = Array<JSONObject>

extension JSONArray  {
    
    /// Convert JSONArray to your Array of custom models.
    /// - Parameters:
    ///     - type: Model class.
    ///     - dateDecodingStrategy: DateDecodingStrategy.
    ///     - keyDecodingStrategy: KeyDecodingStrategy.
    func toArray<T:Decodable>(of type: T.Type, dateDecodingStartegy: JSONDecoder.DateDecodingStrategy? = nil, keyDecodingStartegy: JSONDecoder.KeyDecodingStrategy? = nil) -> [T]? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let decoder = JSONDecoder()
            if let dateStrategy = dateDecodingStartegy {
                decoder.dateDecodingStrategy = dateStrategy
            }
            if let keyStrategy = keyDecodingStartegy {
                decoder.keyDecodingStrategy = keyStrategy
            }
            return try decoder.decode([T].self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
}

extension JSONObject {
    
    /// Covert JSONObject to your model.
    /// - Parameters:
    ///     - type: Model class.
    ///     - dateDecodingStrategy: DateDecodingStrategy.
    ///     - keyDecodingStrategy: KeyDecodingStrategy.
    func to<T:Decodable>(type: T.Type, dateDecodingStartegy: JSONDecoder.DateDecodingStrategy? = nil, keyDecodingStartegy: JSONDecoder.KeyDecodingStrategy? = nil) -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let decoder = JSONDecoder()
            if let dateStrategy = dateDecodingStartegy {
                decoder.dateDecodingStrategy = dateStrategy
            }
            if let keyStrategy = keyDecodingStartegy {
                decoder.keyDecodingStrategy = keyStrategy
            }
            return try decoder.decode(type, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    static func from<T:Decodable>(path: String, type: T.Type, dateDecodingStartegy: JSONDecoder.DateDecodingStrategy? = nil, keyDecodingStartegy: JSONDecoder.KeyDecodingStrategy? = nil) -> T? {
        guard let json = getJSON(from: path) as? JSONObject else {
            return nil
        }
        return json.to(type: APIResult<Array<CarwashVisit>>.self, dateDecodingStartegy: dateDecodingStartegy, keyDecodingStartegy: keyDecodingStartegy) as? T
    }
    
}

func getJSON(from path: String) -> Any? {
    let url = URL(fileURLWithPath: path)
    do {
        let jsonData = try Data(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
        return try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
        
    } catch {
        print(error)
    }
    return nil
}

extension String {
    
    /// Convert to json element
    func toJson() -> Any? {
        let stringData = data(using: .utf8)!
        do {
            return try JSONSerialization.jsonObject(with: stringData, options : .allowFragments)
        } catch {
            print(error)
        }
        return nil
    }
    
}
