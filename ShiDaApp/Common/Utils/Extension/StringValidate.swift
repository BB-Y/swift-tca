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
            return LoginError.phoneEmpty.errorDescription
        }
        if !self.isValidPhoneNumber {
            return LoginError.phoneInvalid.errorDescription
        }
        return nil
    }
    
    var checkCodeError: String? {
        if self.isEmpty {
            return LoginError.codeEmpty.errorDescription
        }
        if !self.isValidSixNumber {
            return LoginError.codeInvalid.errorDescription
        }
        return nil
    }
    
    var checkPasswordError: String? {
        if self.isEmpty {
            return LoginError.passwordEmpty.errorDescription
        }
        if !self.isValidSixNumber {
            return LoginError.passwordInvalid.errorDescription
        }
        return nil
    }
}


extension String {
    var url: URL? {
        URL(string: self)
    }
    
    /// 将逗号分隔的字符串转换为字符串数组
    var toStringArray: [String] {
        if self.isEmpty { return [] }
        return self.split(separator: ",").map { String($0) }
    }
    
    /// 添加一个新的字符串到逗号分隔的字符串的开头
    /// - Parameter newItem: 要添加的新字符串
    /// - Returns: 添加后的字符串
    func addToCommaSeparatedList(_ newItem: String) -> String {
        if self.isEmpty { return newItem }
        return newItem + "," + self
    }
    
    /// 限制逗号分隔的字符串中的项目数量
    /// - Parameter limit: 最大项目数量
    /// - Returns: 限制后的字符串
    func limitCommaSeparatedItems(to limit: Int) -> String {
        let components = self.split(separator: ",")
        if components.count <= limit { return self }
        
        let limitedComponents = components.prefix(limit)
        return limitedComponents.joined(separator: ",")
    }
}
