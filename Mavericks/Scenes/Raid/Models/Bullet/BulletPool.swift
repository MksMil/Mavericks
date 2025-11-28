import Foundation

class BulletPool {
    private var inactiveBullets: [BulletModel] = []
    
    let bank: RaidDataSource
    
    init(bank: RaidDataSource) {
        self.bank = bank
    }
    
    func getBullet(inField field: BulletShotigAvailableProtocol) -> BulletModel{
        inactiveBullets.popLast() ?? BulletModel(field: field,
                                                        bank: bank)
    }
    
    func recycleBullet(_ bullet: BulletModel){
        inactiveBullets.append(bullet)
    }
    func clearPool(){
        inactiveBullets.removeAll()
    }
}
