//
//  SDMockable.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/6.
//

import Foundation
protocol SDMockable {
    var json: String{get}
}
extension SDMockable where Self: Codable{
    var mock: Self? {
        if let result = try? JSONDecoder().decode(Self.self, from: json.data(using: .utf8)!) {
            return result
        }
        return nil
    }
}
