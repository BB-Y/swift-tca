import Foundation
import CodableWrappers

/// CodableWrappers使用示例
/// 这个文件展示了如何正确使用CodableWrappers库中的各种装饰器

// 基本用法示例
@CustomCodable
public struct BasicExample: Codable {
    let normalProperty: String
    
    // 不需要额外的CodingKeys枚举
}

// 蛇形命名示例
@CustomCodable @SnakeCase
public struct SnakeCaseExample: Codable {
    let firstName: String  // 将被编码/解码为"first_name"
    let lastName: String   // 将被编码/解码为"last_name"
}

// 日期编码示例
@CustomCodable
public struct DateExample: Codable {
    // 使用从1970年开始的秒数编码日期
    @SecondsSince1970DateCoding
    var createdAt: Date
    
    // 使用ISO8601格式编码日期
    @ISO8601DateCoding
    var updatedAt: Date
    
    // 使用自定义日期格式编码日期
    @DateFormatterCoding<MyCustomDateCoder>
    var birthDate: Date
    
}
struct MyCustomDateCoder: DateFormatterStaticCoder {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
// 自定义编码键示例
@CustomCodable
public struct CustomKeyExample: Codable {
    // 使用自定义键名
    @CustomCodingKey("profile_image")
    var profileImageData: Data
    
    @CustomCodingKey("user_id")
    var id: Int
}

// 组合使用示例
@CustomCodable @SnakeCase
public struct UserProfile: Codable {
    let firstName: String
    let lastName: String
    
    @SecondsSince1970DateCoding
    var joinDate: Date
    
    @CustomCodingKey("profile_data")
    var imageData: Data
    
    // 可选属性
    let email: String?
    
    // 嵌套对象
    let settings: UserSettings
}

@CustomCodable @SnakeCase
public struct UserSettings: Codable {
    let notificationsEnabled: Bool
    let theme: String
}

// 使用示例
extension UserProfile {
    static func decode(from jsonString: String) -> UserProfile? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(UserProfile.self, from: data)
        } catch {
            print("解码错误: \(error)")
            return nil
        }
    }
    
    func encode() -> String? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(self)
            return String(data: data, encoding: .utf8)
        } catch {
            print("编码错误: \(error)")
            return nil
        }
    }
}

/*
使用说明：

1. 确保已正确导入CodableWrappers库
2. 对于整个结构体的命名转换（如蛇形命名），使用@SnakeCase装饰器
3. 对于特定属性的自定义编码，使用相应的属性装饰器
4. 所有使用装饰器的结构体都应该添加@CustomCodable装饰器
5. 不需要手动实现CodingKeys枚举，CodableWrappers会自动处理

常见问题：
- 如果装饰器不起作用，确保结构体标记了@CustomCodable
- 确保使用了正确的装饰器组合
- 检查CodableWrappers库的版本兼容性
*/
