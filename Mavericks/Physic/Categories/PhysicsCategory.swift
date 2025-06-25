import Foundation

// MARK: - Physics Category

struct PhysicsCategory {
    static let None:              UInt32  = 0
    static let Player:            UInt32  = 0b1      // 1
    static let Obstacle:          UInt32  = 0b10     // 2
    static let PlatformBreakable: UInt32  = 0b100    // 4
    static let CoinNormal:        UInt32  = 0b1000   // 8
    static let CoinSpecial:       UInt32  = 0b10000  // 16
    static let Edges:             UInt32  = 0b100000 // 32
}
