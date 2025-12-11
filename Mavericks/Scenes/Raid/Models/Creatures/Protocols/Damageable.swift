import Foundation

protocol Damageable {
    var currentHealth: Int { get }
    var maxHealth: Int { get }
    
    func applyDamage(from damageDealer: DamageDealer)
//    func heal(_ amount: Int)
}

