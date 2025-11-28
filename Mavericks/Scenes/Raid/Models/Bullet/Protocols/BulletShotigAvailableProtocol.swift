import SpriteKit

protocol BulletShotigAvailableProtocol{
    var interactiveNode: SKNode { get }
    func shootBy(tower: TowerModel, onTarget target: MonsterModel)
    func finishShootByBullet(_ bullet: BulletModel)
}
