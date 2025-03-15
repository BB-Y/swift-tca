//
//  TimestampStringCoder.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/15.
//

import Foundation
import CodableWrappers

struct TimestampStringCoder: StaticCoder {
    
    static func decode(from decoder: Decoder) throws -> String {
        if let stringValue = try? Int(from: decoder) {
            let value = String(stringValue)
            return value
        }
        
        else if let stringValue = try? String(from: decoder){
            return stringValue

//            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath,
//                                                                    debugDescription: "Expected \(String.self)) but could not convert \(stringValue) to \(String.self)"))
        }
           
           return ""
       }

       static func encode(value: String, to encoder: Encoder) throws {
           try "\(value)".encode(to: encoder)
       }
}

private extension DateFormatter {
    static let yyyy_MM_dd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
