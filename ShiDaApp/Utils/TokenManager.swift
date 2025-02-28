//
//  TokenManager.swift
//  ShiDaApp
//
//  Created by AI on 2025/2/28.
//

import Foundation
import Security

/// 令牌管理器，负责安全存储和获取访问令牌和刷新令牌
public class TokenManager {
    /// 单例实例
    @MainActor public static let shared = TokenManager()
    
    // 钥匙串服务名称
    private let serviceNameAccess = "com.shida.app.accessToken"
    private let serviceNameRefresh = "com.shida.app.refreshToken"
    
    // 账户名称
    private let accountName = "ShiDaUser"
    
    private init() {}
    
    /// 保存令牌到钥匙串
    /// - Parameters:
    ///   - accessToken: 访问令牌
    ///   - refreshToken: 刷新令牌
    public func saveTokens(accessToken: String, refreshToken: String) {
        saveToken(token: accessToken, serviceName: serviceNameAccess)
        saveToken(token: refreshToken, serviceName: serviceNameRefresh)
    }
    
    /// 获取访问令牌
    /// - Returns: 访问令牌，如果不存在则返回nil
    public func getAccessToken() -> String? {
        return getToken(serviceName: serviceNameAccess)
    }
    
    /// 获取刷新令牌
    /// - Returns: 刷新令牌，如果不存在则返回nil
    public func getRefreshToken() -> String? {
        return getToken(serviceName: serviceNameRefresh)
    }
    
    /// 清除所有令牌
    public func clearTokens() {
        deleteToken(serviceName: serviceNameAccess)
        deleteToken(serviceName: serviceNameRefresh)
    }
    
    // MARK: - 私有方法
    
    /// 保存令牌到钥匙串
    private func saveToken(token: String, serviceName: String) {
        guard let tokenData = token.data(using: .utf8) else { return }
        
        // 查询是否已存在
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: accountName
        ]
        
        // 先尝试删除已有的
        SecItemDelete(query as CFDictionary)
        
        // 添加新的
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: accountName,
            kSecValueData as String: tokenData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        SecItemAdd(addQuery as CFDictionary, nil)
    }
    
    /// 从钥匙串获取令牌
    private func getToken(serviceName: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: accountName,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        }
        
        return nil
    }
    
    /// 从钥匙串删除令牌
    private func deleteToken(serviceName: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: accountName
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
