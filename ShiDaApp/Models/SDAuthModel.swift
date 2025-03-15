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

/// 发送验证码操作类型
enum SDSendCodeType: Int, Codable, Equatable ,Sendable{
    case register = 10      // 注册
    case forgetPassword = 20 // 忘记密码
    case changePhone = 30    // 修改手机号码
    case changeEmail = 40    // 修改邮箱地址
    case changePassword = 50 // 修改密码
    case verify = 60         // 验证
}

/// 新的发送验证码请求模型
public struct SDReqParaSendCode: Codable {
    let opType: SDSendCodeType?
    let phoneNum: String?
    
    init(opType: SDSendCodeType?, phoneNum: String?) {
        self.opType = opType
        self.phoneNum = phoneNum
    }
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
/// 用户审核状态
public enum SDTeacherAuthStatus: Int, Codable, Equatable {
    /// 未申请
    case notApplied = 0
    /// 申请中
    case pending = 1
    /// 审核通过
    case approved = 10
    /// 审核拒绝
    case rejected = 20
}

//MARK: - 响应模型
/// 登录响应模型
struct SDResponseLogin : Codable, Equatable {
    /// 地址
    let address : String?
    /// 审核状态
    let authStatus : SDTeacherAuthStatus?
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




