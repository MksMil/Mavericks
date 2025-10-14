import SpriteKit

//TODO: differentiate monsters for different waves, towers,field,lair,resources etc...
enum TextureKeys: String {
    case monster
    case field
    case tower
    case base
    case lair
    case resource
}

class TextureBank {
    let name: String
    let size: CGFloat
    
    var atlas: SKTexture
    
    var moveRightTextures:[SKTexture] = []
    var moveUpTextures:[SKTexture] = []
    var moveDownTextures:[SKTexture] = []
    
    var all: [TextureKeys: [SKTexture]] = [:]
    
    var normalMap: [SKTexture] = []
    
    init(name: String, size: CGFloat){
        self.name = name
        self.size = size
        self.atlas = SKTexture(imageNamed: name)
        config()
    }
    
    func config(){
//        moveUpTextures = makeTexturesForHeight(6, count: 4)
//        moveDownTextures = makeTexturesForHeight(8, count: 4)
//        moveRightTextures = makeTexturesForHeight(7, count: 4)
        makeMonsterTexture()
        makeTowerTextures()
    }
    
    func makeFieldTexture(){
        
    }
    func makeRoadTexture(){
        
    }
    
    func makeTowerTextures(){
        let atlass = SKTexture(imageNamed: "tower_prototype")
        all[.tower] = []
        for i in 0..<4 {
            let rect = CGRect(
                x: CGFloat(i) * atlass.textureRect().width / 4 ,
                y: 0,
                width: atlass.textureRect().width / 4,
                height: atlass.textureRect().height)
            let texture = SKTexture(rect: rect, in: atlass)
            all[.tower]?.append(texture)
        }
    }
    
    func makeTexturesForHeight(_ h: Int, count: Int, name: String = "") -> [SKTexture]{
        atlas = SKTexture(imageNamed: name)
        var result: [SKTexture] = []
        for i in 0..<count {
            let rect = CGRect(x: CGFloat(i) * atlas.textureRect().width / 4 ,
                              y: CGFloat(h) * atlas.textureRect().height / 12,
                              width: atlas.textureRect().width / 4,
                              height: atlas.textureRect().height / 12)
            let texture = SKTexture(rect: rect, in: atlas)
            result.append(texture)
        }
        return result
    }
    func makeMonsterTexture(){
        let atlas = SKTextureAtlas(named: "Monster")
                
        let headTexture = atlas.textureNamed("monster_head")
        let bodyTexture = atlas.textureNamed("monster_body")
        let leftLegTexture = atlas.textureNamed("monster_left_leg")
        let rightLegTexture = atlas.textureNamed("monster_right_leg")
        let leftArmTexture = atlas.textureNamed("monster_left_arm")
        let rightArmTexture = atlas.textureNamed("monster_right_arm")
        
        let cmbTextures = TextureFactory.makeSequence(
            headTexture: headTexture,
            bodyTexture: bodyTexture,
            leftArmTexture: leftArmTexture,
            rightArmTexture: rightArmTexture,
            leftLegTexture: leftLegTexture,
            rightLegTexture: rightLegTexture,
            angle: CGFloat.pi / 8
        )
        
        moveUpTextures = cmbTextures
        moveDownTextures = cmbTextures
        moveRightTextures = cmbTextures
        
//        normalMap = TextureFactory.generarateNormalMapsFrom(textures: cmbTextures)
    }
}
