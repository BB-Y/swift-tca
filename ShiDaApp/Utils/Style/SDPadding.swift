//
//  SDPadding.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/3.
//

import Foundation
import UIKit

extension Double {
    @MainActor func pad(_ padding: Double) -> Double {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return padding
        } else {
            return self
        }
    }
}
