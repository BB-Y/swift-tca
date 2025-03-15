//
//  SharedKey.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/4.
//

import Foundation
import ComposableArchitecture

/// 存储在 UserDefault
extension SharedKey where Self == AppStorageKey<String?> {
  static var shareUserToken: Self {
    appStorage("SDShareUserToken")
  }
}

extension SharedKey where Self == AppStorageKey<Data?> {
  static var shareUserInfo: Self {
    appStorage("SDShareUserInfo")
  }
}

// 添加搜索历史的SharedKey
extension SharedKey where Self == AppStorageKey<String> {
  static var shareSearchHistory: Self {
    appStorage("SDSearchHistory")
  }
}

extension SharedKey where Self == InMemoryKey<Bool> {
  static var shareAcceptProtocol: Self {
      inMemory("SDShareAcceptProtocol")
  }
}

enum LoginStatus: Int, Codable {
    case notLogin
    case login
    case logout
    
    var isLogin: Bool {
        self == .login
    }
}

extension SharedKey where Self == AppStorageKey<LoginStatus> {
  static var shareLoginStatus: Self {
    appStorage("SDShareLoginStatus")
  }
}
