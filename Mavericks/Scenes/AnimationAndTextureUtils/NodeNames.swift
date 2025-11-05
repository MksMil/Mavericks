// Naming for nodes

enum NodeNames: String{
    case start
    
    case hudButton
    case menuButton
    
    case arrow, poison, fire,frost, electro, stun
    case resume, restart, options, exit
    case pause
    
    case camera
    
    case base
    case resource
    case monsterSpawn
    case block
    case road
    case field
    
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
}
