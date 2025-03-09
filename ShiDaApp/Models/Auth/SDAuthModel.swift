//
//  SDAuthModel.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/6.
//

import Foundation
import ComposableArchitecture
import CodableWrappers



//MARK: - 请求模型
/// 登录请求模型
public struct SDReqParaLoginPassword: Codable {
    /// 手机
    public let phone: String
    /// 密码
    public let password: String
    
    public let userType: SDUserType?
}

public struct SDReqParaLoginSMS: Codable {
    /// 手机
    public let phone: String
    /// 验证码
    public let smsCode: String
    public let userType: SDUserType?

}
/// 注册请求模型
public struct SDReqParaRegister: Codable {
    public let phone: String
    public let smsCode: String
    public let userType: SDUserType
}
/// 忘记密码请求模型
public struct SDReqParaForgetPassword: Codable {
    /// 手机
    public let phoneNum: String
    /// 密码
    public let password: String
    
    public let smsCode: String
}
/// 验证手机号请求模型
public struct SDReqParaValidatePhone: Codable {
    
    public let phone: String
    
    public let smsCode: String
   
}

struct SDReqParaThirdBindAccountExist: Codable {
    let thirdpartyAccount: String
    let thirdpartyBindType: SDThirdPartyType
}
struct SDReqParaThirdLogin: Codable {
    let thirdpartyAccount: String
    let thirdpartyBindType: SDThirdPartyType
    let userType: SDUserType?

}

struct SDReqParaThirdRegist : Codable {
    let phone : String?
    let thirdpartyAccount : String?
    let thirdpartyAvatarUrl : String?
    let thirdpartyBindType : Int?
    let thirdpartyMailbox : String?
    let thirdpartyNickName : String?
    let userType : SDUserType?
}

struct SDReqParaSendCode : Codable {

    let isForget : Bool?
    let isRegister : Bool?
    let phoneNum : String?
    let type : SDSendCodeUserType?
    
   
    init(isForget: Bool?, isRegister: Bool?, phoneNum: String?, type: SDSendCodeUserType?) {
        self.isForget = isForget
        self.isRegister = isRegister
        self.phoneNum = phoneNum
        self.type = type
    }
    init(_ phone: String, sendCodeType: SDSendCodeType) {
        let isForget: Bool = sendCodeType == .forget
        let isRegister: Bool = sendCodeType == .bind

        self.init(isForget: isForget, isRegister: isRegister, phoneNum: phone, type: .app)
    }
}
enum SDSendCodeType: Int, Codable, Equatable ,Sendable{
    case forget
    case bind
    case login
}
/// 发送验证码用户类型
public enum SDSendCodeUserType: Int, Codable {
    case app = 20
    case server = 10
}
/// 用户登录身份
public enum SDUserType: Int, Codable {
    case student = 20
    case teacher = 10
}
public enum SDThirdPartyType: Int, Codable {
    case wechat = 10
    case qq = 20
    case apple = 30
}
//MARK: - 响应模型
/// 登录响应模型
struct SDResponseLogin : Codable, Equatable {
    /// 地址
    let address : String?
    /// 审核状态（0-未申请 1-申请中 10-审核通过 20-审核拒绝）
    let authStatus : Int?
    /// 城市编码
    let city : Int?
    /// 创建时间
    let createDatetime : String?
    /// 部门
    let deparment : String?
    /// 领域
    let field : String?
    /// 用户id
    let id : Int?
    /// 输入的专业
    let inputMajor : String?
    /// 工号
    let jobId : String?
    /// 职称
    let jobTitle : String?
    /// 最后登录时间
    let lastLoginDatetime : String?
    /// 等级
    let level : String?
    /// 邮箱
    let mail : String?
    /// 专业
    let major : String?
    /// 专业ID
    let majorId : Int?
    /// 姓名
    let name : String?
    /// 手机号
    let phone : String?
    /// 头像
    let photo : String?
    /// 职位
    let position : String?
    /// 邮政编码
    let postalCode : String?
    /// 省份编码
    let province : Int?
    /// 学校ID
    let schoolId : Int?
    /// 用户状态（10-正常 20-禁用 30-锁定）
    let status : Int?
    
    /// 登录令牌
    let token : String?
    /// 用户类型（10-教师 20-学生）
    var userType : SDUserType?
}


