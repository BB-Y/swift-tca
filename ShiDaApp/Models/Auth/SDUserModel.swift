//
//  SDUserModel.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/7.
//

import Foundation

/// 第三方账号信息模型
public struct SDThirdPartyAccountInfo: Codable, Equatable {
    let id: Int?
    let thirdpartyAccount: String?
    let thirdpartyAvatarUrl: String?
    let thirdpartyBindTime: String?
    let thirdpartyBindType: Int?
    let thirdpartyMailbox: String?
    let thirdpartyNickName: String?
    let userId: Int?
}

/// 用户信息响应模型
public struct SDResponseUserInfo: Codable, Equatable {
    let id: Int?
    let name: String?
    let phone: String?
    let thirdparthAccountList: [SDThirdPartyAccountInfo]?
    let userType: SDUserType?
}