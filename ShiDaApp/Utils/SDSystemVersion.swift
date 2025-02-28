//
//  SDSystemVersion.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/1.
//

import Foundation
import SwiftUI

/// 系统版本管理工具类
/// 用于封装系统版本判断逻辑，使代码更加清晰和可维护
public enum SDSystemVersion {
    /// 检查是否为iOS 16及以上版本
    public static var isIOS16OrLater: Bool {
        if #available(iOS 16, *) {
            return true
        }
        return false
    }
    
    /// 检查是否为iOS 15及以上版本
    public static var isIOS15OrLater: Bool {
        if #available(iOS 15, *) {
            return true
        }
        return false
    }
    
    /// 检查是否为iOS 14及以上版本
    public static var isIOS14OrLater: Bool {
        if #available(iOS 14, *) {
            return true
        }
        return false
    }
    
    /// 检查是否为iOS 13及以上版本
    public static var isIOS13OrLater: Bool {
        if #available(iOS 13, *) {
            return true
        }
        return false
    }
    
    /// 获取当前系统版本号
//    public static var currentVersion: String {
//        return UIDevice.current.systemVersion
//    }
    
    /// 在iOS 16及以上版本执行闭包
    /// - Parameter action: 要执行的闭包
    public static func ifIOS16OrLater(_ action: () -> Void) {
        if #available(iOS 16, *) {
            action()
        }
    }
    
    /// 根据iOS版本执行不同的闭包
    /// - Parameters:
    ///   - ios16Action: iOS 16及以上版本执行的闭包
    ///   - fallbackAction: 低于iOS 16版本执行的闭包
    public static func ifIOS16OrLater<T>(
        _ ios16Action: () -> T,
        else fallbackAction: () -> T
    ) -> T {
        if #available(iOS 16, *) {
            return ios16Action()
        } else {
            return fallbackAction()
        }
    }
    
    /// 在iOS 15及以上版本执行闭包
    /// - Parameter action: 要执行的闭包
    public static func ifIOS15OrLater(_ action: () -> Void) {
        if #available(iOS 15, *) {
            action()
        }
    }
    
    /// 根据iOS版本执行不同的闭包
    /// - Parameters:
    ///   - ios15Action: iOS 15及以上版本执行的闭包
    ///   - fallbackAction: 低于iOS 15版本执行的闭包
    public static func ifIOS15OrLater<T>(
        _ ios15Action: () -> T,
        else fallbackAction: () -> T
    ) -> T {
        if #available(iOS 15, *) {
            return ios15Action()
        } else {
            return fallbackAction()
        }
    }
}

/// SwiftUI视图扩展，用于根据iOS版本条件性地渲染视图
extension View {
    /// 根据iOS版本条件性地应用修饰符
    /// - Parameters:
    ///   - condition: 条件
    ///   - modifier: 满足条件时应用的修饰符
    /// - Returns: 修饰后的视图
    @ViewBuilder
    public func `if`<Content: View>(_ condition: Bool, modifier: (Self) -> Content) -> some View {
        if condition {
            modifier(self)
        } else {
            self
        }
    }
    
    /// 根据iOS版本条件性地应用修饰符
    /// - Parameters:
    ///   - ios16Modifier: iOS 16及以上版本应用的修饰符
    ///   - fallbackModifier: 低于iOS 16版本应用的修饰符
    /// - Returns: 修饰后的视图
    @ViewBuilder
    public func ifIOS16<TrueContent: View, FalseContent: View>(
        then ios16Modifier: @escaping (Self) -> TrueContent,
        else fallbackModifier: @escaping (Self) -> FalseContent
    ) -> some View {
        if SDSystemVersion.isIOS16OrLater {
            ios16Modifier(self)
        } else {
            fallbackModifier(self)
        }
    }
    
    /// 仅在iOS 16及以上版本应用修饰符
    /// - Parameter ios16Modifier: iOS 16及以上版本应用的修饰符
    /// - Returns: 修饰后的视图
    @ViewBuilder
    public func ifIOS16<Content: View>(then ios16Modifier: @escaping (Self) -> Content) -> some View {
        if SDSystemVersion.isIOS16OrLater {
            ios16Modifier(self)
        } else {
            self
        }
    }
}
