//
//  CodeKeyManager.swift
//  
//
//  Created by JSilver on 2023/03/30.
//

import Service

final class CodeKeyManager {
    static let maxKeyCount: Int = 5
    static let recoveryInterval: TimeInterval = 5 * 60
    
    // MARK: - Property
    @Store
    private(set) var codeKeyCount: Int
    @Store
    private(set) var latestKeyRecoveryDate: Date?
    
    var hasKey: Bool { codeKeyCount > 0 }
    
    private weak var timer: Timer? {
        didSet {
            oldValue?.invalidate()
        }
    }
    
    // MARK: - Initializer
    init(storage: any Storage) {
        // Set stored date.
        self._codeKeyCount = Store(storage, for: .codeKeys, default: CodeKeyManager.maxKeyCount)
        self._latestKeyRecoveryDate = Store(storage, for: .latestKeyRecoveryDate)
    }
    
    // MARK: - Public
    /// Use the code key and start recovery system.
    func use(at date: Date) {
        guard codeKeyCount > 0 else { return }
        // Subtract Key
        self.codeKeyCount = codeKeyCount - 1
        
        guard timer == nil else { return }
        startRecovery(from: date)
    }
    
    /// Check the code key recovery based on current date.
    func checkRecovery(current date: Date) {
        guard let latestKeyRecoveryDate else { return }
        
        guard date > latestKeyRecoveryDate else {
            // Start recovery when current date not pass the recovery date yet.
            startRecovery(from: latestKeyRecoveryDate)
            return
        }
        
        // Count the number of keys to recover.
        let recoveredKeys = min(
            Int(date.timeIntervalSince(latestKeyRecoveryDate) / CodeKeyManager.recoveryInterval),
            CodeKeyManager.maxKeyCount - codeKeyCount
        )
        
        Logger.info(
            "\(recoveredKeys) Code keys recovered during ide.",
            userInfo: [
                .category: "CODE SERVICE"
            ]
        )
        
        // Recover code key.
        self.codeKeyCount = codeKeyCount + recoveredKeys
        guard self.codeKeyCount < CodeKeyManager.maxKeyCount else {
            // Initialize the latest key recovery date if the key has already been fully recovered.
            self.latestKeyRecoveryDate = nil
            return
        }
        
        // Start recovery from next key recovery date.
        startRecovery(from: latestKeyRecoveryDate.addingTimeInterval(CodeKeyManager.recoveryInterval * Double(recoveredKeys)))
    }
    
    func chargeCodeKeys(amount: Int? = nil) {
        // Charge code keys.
        let chargedCodeKeys = min(codeKeyCount + (amount ?? CodeKeyManager.maxKeyCount), CodeKeyManager.maxKeyCount)
        self.codeKeyCount = chargedCodeKeys
        
        Logger.info(
            "Charged code key to \(chargedCodeKeys)",
            userInfo: [
                .category: "CODE SERVICE"
            ]
        )
        
        guard chargedCodeKeys == CodeKeyManager.maxKeyCount else { return }
        
        Logger.info(
            "Code keys are fulled.",
            userInfo: [
                .category: "CODE SERVICE"
            ]
        )
        
        // Reset recovery system.
        latestKeyRecoveryDate = nil
        timer?.invalidate()
    }
    
    // MARK: - Private
    private func startRecovery(from date: Date) {
        guard codeKeyCount < CodeKeyManager.maxKeyCount else {
            // Return when recovery system already running.
            return
        }
        
        latestKeyRecoveryDate = date
        // Calculate the date of the next generation of the code key.
        let recoveryDate = date.addingTimeInterval(CodeKeyManager.recoveryInterval)
        
        Logger.info("""
            Started code key recovery.
              🗓️ Additional code key will recover at \(recoveryDate.formatted("yyyy-MM-dd hh:mm:ss"))."
            """,
            userInfo: [
                .category: "CODE SERVICE"
            ]
        )
        
        // Run recovery timer.
        let timer = Timer(
            fire: recoveryDate,
            interval: CodeKeyManager.recoveryInterval,
            repeats: true
        ) { [weak self] timer in
            guard let self else { return }
            
            // Recovery a code key.
            let currentCodeKeys = min(self.codeKeyCount + 1, CodeKeyManager.maxKeyCount)
            self.codeKeyCount = currentCodeKeys
            
            Logger.info(
                "Additional code key recovered to \(currentCodeKeys)",
                userInfo: [
                    .category: "CODE SERVICE"
                ]
            )
            
            guard currentCodeKeys < CodeKeyManager.maxKeyCount else {
                // End of recovering code key are fulled.
                Logger.info(
                    "Code keys are fulled.",
                    userInfo: [
                        .category: "CODE SERVICE"
                    ]
                )
                
                // Reset recovery state.
                self.latestKeyRecoveryDate = nil
                timer.invalidate()
                return
            }
            
            // Record latest key recovery date.
            self.latestKeyRecoveryDate = timer.fireDate
            let recoveryDate = timer.fireDate.addingTimeInterval(CodeKeyManager.recoveryInterval)
            
            Logger.info("""
                Next recovery date at \(recoveryDate.formatted("yyyy-MM-dd hh:mm:ss"))."
                """,
                userInfo: [
                    .category: "CODE SERVICE"
                ]
            )
        }
        
        RunLoop.main.add(timer, forMode: .default)
        self.timer = timer
    }
}
