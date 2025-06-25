import SpriteKit

enum TextureBank: String {
    
    case hero
    
//    func textureForState(hState: UnitState, vState: UnitVState){
//        switch vState {
//            case .jump:
//                return
//            case .fall:
//                <#code#>
//            case .onGround:
//                <#code#>
//        }
//    }
    
    static let hero_idleTextures: [SKTexture] = {
        var array = [SKTexture]()
        (0...11).forEach { num in
            array.append(SKTexture(imageNamed: "teddy_idle_\(num)"))
        }
        return array
    }()
 
    static let hero_moveLeftTextures: [SKTexture] = {
        var array = [SKTexture]()
        (0...11).forEach { num in
            array.append(SKTexture(imageNamed: "teddy_walk_\(num)"))
        }
        return array
    }()
    
    static let hero_jumpBeginTextures: [SKTexture] = {
        var array = [SKTexture]()
        (0...7).forEach { num in
            array.append(SKTexture(imageNamed: "teddy_jumpThrow_\(num)"))
        }
        return array
    }()
    
    static let hero_jumpUpTextures: [SKTexture] = {
        var array = [SKTexture]()
        (0...2).forEach { num in
            array.append(SKTexture(imageNamed: "teddy_jumpUp_\(num)"))
        }
        return array
    }()
    
    static let hero_jumpDownTextures: [SKTexture] = {
        var array = [SKTexture]()
        (0...4).forEach { num in
            array.append(SKTexture(imageNamed: "teddy_jumpFall_\(num)"))
        }
        return array
    }()
}
