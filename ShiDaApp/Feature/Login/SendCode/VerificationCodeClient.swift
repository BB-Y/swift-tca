import Foundation
import ComposableArchitecture
import Combine

// 定义协议
protocol VerificationCodeClientProtocol {
    // 当前倒计时状态
    var isCounting: Bool { get }
    var currentNumber: Int { get }
    
    // 发送验证码
    func sendCode(phone: String, type: SDSendCodeType) async throws -> Bool
    
    // 获取当前倒计时状态的Publisher
    var countdownPublisher: AnyPublisher<(isCounting: Bool, seconds: Int), Never> { get }
}

// 实现客户端
class LiveVerificationCodeClient: VerificationCodeClientProtocol {
    // 存储属性
    @Dependency(\.authClient) var authClient
    @Dependency(\.continuousClock) var continuousClock
    
    private let countdownSubject = CurrentValueSubject<(isCounting: Bool, seconds: Int), Never>((false, 0))
    private var countdownTask: Task<Void, Never>?
    private let startNumber: Int
    
    // 公开属性
    var isCounting: Bool { countdownSubject.value.isCounting }
    var currentNumber: Int { countdownSubject.value.seconds }
    var countdownPublisher: AnyPublisher<(isCounting: Bool, seconds: Int), Never> {
        countdownSubject.eraseToAnyPublisher()
    }
    
    init(startNumber: Int = 10) {
        self.startNumber = startNumber
    }
    
    func sendCode(phone: String, type: SDSendCodeType) async throws -> Bool {
        // 如果正在倒计时，不允许发送
        if isCounting {
            throw VerificationCodeError.countingDown
        }
        
        // 检查手机号
        let para = SDReqParaSendCode(opType: type, phoneNum: phone)
        if let errorMsg = para.phoneNum?.checkPhoneError {
            throw VerificationCodeError.invalidPhone(errorMsg)
        }
        
        // 测试账号直接返回成功
        if phone.hasPrefix("1999") {
            startCountdown()
            return true
        }
        
        // 发送验证码
        let result = try await authClient.phoneCode(para)
        
        // 如果成功，开始倒计时
        if result {
            startCountdown()
        }
        
        return result
    }
    
    private func startCountdown() {
        // 取消之前的任务
        countdownTask?.cancel()
        
        // 创建新的倒计时任务
        countdownTask = Task { [weak self] in
            guard let self = self else { return }
            
            // 设置初始状态
            var currentCount = self.startNumber
            self.countdownSubject.send((true, currentCount))
            
            // 开始倒计时
            for await _ in self.continuousClock.timer(interval: .seconds(1)) {
                guard !Task.isCancelled else { break }
                
                if currentCount > 0 {
                    currentCount -= 1
                    self.countdownSubject.send((true, currentCount))
                } else {
                    self.countdownSubject.send((false, 0))
                    break
                }
            }
        }
    }
    
    deinit {
        countdownTask?.cancel()
    }
}

// 错误类型
enum VerificationCodeError: Error, LocalizedError {
    case countingDown
    case invalidPhone(String)
    case sendFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .countingDown:
            return "请等待倒计时结束后再发送"
        case .invalidPhone(let message):
            return message
        case .sendFailed(let message):
            return message
        }
    }
}

// 依赖注入设置
private enum VerificationCodeClientKey: DependencyKey {
    static let liveValue: VerificationCodeClientProtocol = LiveVerificationCodeClient()
    
    // 测试值
    static let testValue: VerificationCodeClientProtocol = LiveVerificationCodeClient()
}

extension DependencyValues {
    var verificationCodeClient: VerificationCodeClientProtocol {
        get { self[VerificationCodeClientKey.self] }
        set { self[VerificationCodeClientKey.self] = newValue }
    }
}

// 测试实现
class TestVerificationCodeClient: VerificationCodeClientProtocol {
    private let countdownSubject = CurrentValueSubject<(isCounting: Bool, seconds: Int), Never>((false, 0))
    
    var isCounting: Bool = false
    var currentNumber: Int = 0
    var countdownPublisher: AnyPublisher<(isCounting: Bool, seconds: Int), Never> {
        countdownSubject.eraseToAnyPublisher()
    }
    
    func sendCode(phone: String, type: SDSendCodeType) async throws -> Bool {
        if isCounting {
            throw VerificationCodeError.countingDown
        }
        
        // 模拟发送成功
        isCounting = true
        currentNumber = 10
        countdownSubject.send((true, currentNumber))
        
        // 这里可以根据测试需求返回不同结果
        return true
    }
    
    // 用于测试的辅助方法
    func simulateCountdownFinished() {
        isCounting = false
        currentNumber = 0
        countdownSubject.send((false, 0))
    }
}
