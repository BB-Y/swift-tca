import Foundation

extension String {
    
    /// 校验是否为11位手机号
    var isValidPhoneNumber: Bool {
        let phoneRegex = "^1[0-9]{10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }
    
    /// 校验密码是否同时包含数字和字母
    var isValidPassword: Bool {
        // 包含数字的正则
        let numberRegex = ".*[0-9]+.*"
        // 包含字母的正则
        let letterRegex = ".*[A-Za-z]+.*"
        
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", numberRegex)
        let letterPredicate = NSPredicate(format: "SELF MATCHES %@", letterRegex)
        
        return numberPredicate.evaluate(with: self) && letterPredicate.evaluate(with: self)
    }
    
    /// 校验是否为6位数字
    var isValidSixNumber: Bool {
        let regex = "^[0-9]{6}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var checkPhoneError: String? {
        if self.isEmpty {
            return "手机号不能为空"
        }
        if !self.isValidPhoneNumber {
            return "手机号格式错误"
        }
        return nil
    }
    
    var checkCodeError: String? {
        if self.isEmpty {
            return "验证码不能为空"
            
        }
        if !self.isValidSixNumber {
            return "验证码格式错误"
        }
        return nil
    }
    var checkPasswordError: String? {
        if self.isEmpty {
            return "密码不能为空"
            
        }
        if !self.isValidSixNumber {
            return "密码格式错误"
        }
        return nil
    }
}
