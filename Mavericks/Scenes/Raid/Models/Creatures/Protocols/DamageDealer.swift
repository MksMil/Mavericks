import Foundation

protocol DamageDealer {
    var attack: DamageModel { get }
    var effectDuration: CGFloat { get }
    var type: TowerType { get }
}
