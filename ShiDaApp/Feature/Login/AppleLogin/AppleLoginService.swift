//
//  AppleLoginService.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/17.
//

import Foundation
import AuthenticationServices
class AppleLoginService: NSObject {
   
    
    
    typealias CompletBlock = (Result<[String: Any], ThirdError>) -> Void
    
    enum ThirdError: Error {
        case cancel
        case failed
    }
    static let shared = AppleLoginService()
    
    var wechatBlock: CompletBlock?
    var qqBlock: CompletBlock?
    var weiboBlock: CompletBlock?
    var appleBlock: CompletBlock?
    var wxPayBlock: CompletBlock?

    func startLogin(with type: SDThirdPartyType, complet: @escaping CompletBlock) {
        switch type {
        case .wechat:
            startLoginWithWechat(complet: complet)
        case .qq:
            startLoginWithQQ(complet: complet)
       
        case .apple:
            startLoginWithApple(complet: complet)
        default: break
        }
    }

    private func startLoginWithWechat(complet: CompletBlock? = nil) {
//        self.wechatBlock = complet
//        
//        let req = SendAuthReq()
//        req.openID = "123"
//        req.scope = "snsapi_userinfo"
//        req.state = "speechYIXI"
//       
//        WXApi.send(req) { suc in
//            //print(suc)
//            //self.loginStatus = .phoneBinded
//        }
        //self.loginStatus = .phoneBinded
    }
//    private func umAuth(type: UMSocialPlatformType, complet: CompletBlock? = nil) {
//        UMSocialManager.default().getUserInfo(with: type, currentViewController: nil) { result, error in
//            if let error = error as NSError? {
//                
//                if error.code == 2009 {
//                    complet?(.failure(.cancel))
//                    YXToast.showToast("操作取消")
//                } else {
//                    complet?(.failure(.failed))
//                    YXToast.showToast("授权失败")
//                }
//            } else {
//                if let result = result as? UMSocialUserInfoResponse {
//                    var para: [String : Any] = [:]
//                    para["code"] = 0
//                    para["nickname"] = result.name
//                    para["avatar"] = result.iconurl
//                    para["gender"] = result.unionGender == "男" ? 1 : 2
//                    if type == .QQ {
//                        para["qq_openid"] = result.openid
//                        para["qq_uid"] = result.unionId
//                    } else if type == .sina {
//                        para["weibo_uid"] = result.uid
//                    }
//                    complet?(.success(para))
//                }
//            }
//        }
//        
//    }
 
    private func startLoginWithQQ(complet: CompletBlock? = nil) {
//        self.qqBlock = complet
//        let type: UMSocialPlatformType = .QQ
//        umAuth(type: type, complet: complet)
    }
    private func startLoginWithApple(complet: CompletBlock? = nil) {
        self.appleBlock = complet
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        let appleIDProvider =  ASAuthorizationAppleIDProvider()
        // 创建新的AppleID 授权请求
        let appleIDRequest = appleIDProvider.createRequest()
        // 在用户授权期间请求的联系信息
        appleIDRequest.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [appleIDRequest])
        authorizationController.delegate = self
        //authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
}


//MARK: - apple
extension AppleLoginService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            var fullname: String = ""
            //let user = appleIDCredential.user
            // 使用过授权的，可能获取不到以下三个参数
            if let familyName = appleIDCredential.fullName?.familyName {
                fullname.append(familyName)
            }
            if let givenName = appleIDCredential.fullName?.givenName {
                fullname.append(givenName)
            }
            //let email = appleIDCredential.email
           // let authorizationCode = appleIDCredential.authorizationCode
            //let authorizationCodeStr = String(data: authorizationCode!, encoding: .utf8)

            if let identityToken = appleIDCredential.identityToken {
                
                // 服务器验证需要使用的参数
                let identityTokenStr = String(data: identityToken, encoding: .utf8)
                let para = ["apple_token": identityTokenStr ?? ""]
                appleBlock?(.success(para))
            } else {
                appleBlock?(.failure(.failed))
            }
        } else {
            appleBlock?(.failure(.failed))
        }
    }
}
//extension AppleLoginService: ASAuthorizationControllerPresentationContextProviding {
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return //YXLayoutConfig.keyWindow
//    }
//}
