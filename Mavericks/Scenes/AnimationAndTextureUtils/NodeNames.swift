// Naming for nodes

enum NodeNames: String{
    case start
    
    case hudButton
    case settings
    case bg
    
    case sell,upgrade
    case blockSell, blockUpgrade
    case cancel
    case arrow, poison, fire,frost, electro, stun
    case resume, restart, options, exit
    case pause
    
    case camera
    
    case base
    case resource
    case monsterSpawn
    case block
    case trap
    case road
    case field
    case tower
    
    case monster
}

extension NodeNames {
    static let towers: [String] = [
        NodeNames.arrow,
        NodeNames.poison,
        NodeNames.fire,
        NodeNames.frost,
        NodeNames.electro,
        NodeNames.stun,
    ].map{$0.rawValue}
    
    static let towerModify: [String] = [
        NodeNames.sell,
        NodeNames.upgrade,
        NodeNames.cancel
    ].map{$0.rawValue}
    
    static let roadBuildings: [String] = [
        NodeNames.block,
        NodeNames.trap,
        NodeNames.cancel
    ].map{$0.rawValue}
    
    //TODO: - общая логика для меню модификации для башен и блоков
    static let roadBuildingsModify: [String] = [
        NodeNames.blockSell,
        NodeNames.blockUpgrade,
        NodeNames.cancel
    ].map{$0.rawValue}
}
