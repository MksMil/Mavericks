import SpriteKit

//TODO: differentiate monsters for different waves, towers,field,lair,resources etc...
enum TextureKeys: String {
    case monster
    case field
    case tower
    case block
    case road
    case base
    case spawn
    case resource
    case hudButton
    case hudMenuTowerCase
    case hudMenuBlockCase
    case hudMenuUpdSellCase
}

class TextureBank: RaidDataSource{
    let levelInfo: String
    let cellSize: CGFloat
        
    var moveRightTextures:[SKTexture] = []
    var moveUpTextures:[SKTexture] = []
    var moveDownTextures:[SKTexture] = []
    
    var towerTextures: [SKTexture] = []
    var blockTextures: [SKTexture] = []
    
    var hudTextures: [SKTexture] = []
    var towerMenuTextures: [SKTexture] = []
    var upgradeSellTextures: [SKTexture] = []
    var pauseMenuTextures: [SKTexture] = []
    
    var fieldTextures: [SKTexture] = []
    var roadTextures: [SKTexture] = []
    
    //for loading screen
    var progress: Int = 0
    
//    var normalMap: [SKTexture] = []
    
    init(levelInfo: String, cellSize: CGFloat){
        self.levelInfo = levelInfo
        self.cellSize = cellSize
        config()
        Task{
           await load()
        }
    }
    
    func load() async {
        await SKTexture.preload(moveUpTextures)
        //change progress state
        await SKTexture.preload(moveDownTextures)
        //change progress state
        await SKTexture.preload(moveRightTextures)
        //change progress state
        await SKTexture.preload(hudTextures)
        //change progress state
        await SKTexture.preload(towerTextures)
        //change progress state
        await SKTexture.preload(upgradeSellTextures)
        //change progress state
        await SKTexture.preload(fieldTextures)
        //change progress state
        await SKTexture.preload(pauseMenuTextures)
        //change progress state
        await SKTexture.preload(roadTextures)
        //change progress state
        await SKTexture.preload(blockTextures)
        //change progress state

    }
    
    func config(){
        makeFieldTexture()
        makeRoadTexture()
        makeMonsterTexture()
        makeTowerTextures()
        makeHudMenuUpgradeSellButtonsTextures()
        makeHudMenuTowersButtonsTextures()
        makePauseMenuTextures()
        makeBlockTexture()
        makeHudButtonsTextures()
    }
    
}
// MARK: - HUD
extension TextureBank {
    // MARK: Hud Buttons (settings, run, pause, cancel)
    func makeHudButtonsTextures(){
        let pauseMenuAtlas = SKTexture(imageNamed: "settingsHUD")
        //from bottom to top
        for j in 0..<4{
            for i in 0..<2 {
                let rect = CGRect(
                    x: CGFloat(i) * pauseMenuAtlas.textureRect().width / 2 ,
                    y: CGFloat(j) * pauseMenuAtlas.textureRect().height / 4,
                    width: pauseMenuAtlas.textureRect().width / 2,
                    height:pauseMenuAtlas.textureRect().height / 4)
                let texture = SKTexture(rect: rect, in: pauseMenuAtlas)
                hudTextures.append(texture)
            }
        }
    }
    // MARK: PauseMenu buttons (resume,restart,options, exit)
    func makePauseMenuTextures(){
        let pauseMenuAtlas = SKTexture(imageNamed: "pauseMenu")
        for i in 0..<4 {
            let rect = CGRect(
                x: CGFloat(i) * pauseMenuAtlas.textureRect().width / 4 ,
                y: 0,
                width: pauseMenuAtlas.textureRect().width / 4,
                height:pauseMenuAtlas.textureRect().height)
            let texture = SKTexture(rect: rect, in: pauseMenuAtlas)
            pauseMenuTextures.append(texture)
        }
    }
    // MARK: Sell/Upgrade
    func makeHudMenuUpgradeSellButtonsTextures(){
        let upgradeAtlas = SKTexture(imageNamed: "sellUpgrade")
        
        for i in 0..<2 {
            let rect = CGRect(
                x: CGFloat(i) * upgradeAtlas.textureRect().width / 2 ,
                y: 0,
                width: upgradeAtlas.textureRect().width / 2,
                height: upgradeAtlas.textureRect().height)
            let texture = SKTexture(rect: rect, in: upgradeAtlas)
            upgradeSellTextures.append(texture)
        }
    }
    // MARK: Towers choise buttons
    func makeHudMenuTowersButtonsTextures(){
        let towerAtlas = SKTexture(imageNamed: "towers")
        for i in 0..<6 {
            let rect = CGRect(
                x: CGFloat(i) * towerAtlas.textureRect().width / 6 ,
                y: 0,
                width: towerAtlas.textureRect().width / 6,
                height: towerAtlas.textureRect().height)
            let texture = SKTexture(rect: rect, in: towerAtlas)
            towerMenuTextures.append(texture)
        }
//        print("textures loaded \(towerMenuTextures.count), \(upgradeSellTextures.count)")
    }
}

// MARK: - Road
extension TextureBank {
    func makeRoadTexture(){
        let texture = SKTexture(imageNamed: "road")
//        for i in 0..<1 {
//            let rect = CGRect(
//                x: CGFloat(i) * atlas.textureRect().width / 2 ,
//                y: 0,
//                width: atlas.textureRect().width / 2,
//                height: atlas.textureRect().height)
//            let texture = SKTexture(rect: rect, in: atlas)
            roadTextures.append(texture)
//        }

    }
}

// MARK: - Field
extension TextureBank{
    func makeFieldTexture(){
        let atlas = SKTexture(imageNamed: "field")
        for i in 0..<2 {
            let rect = CGRect(
                x: CGFloat(i) * atlas.textureRect().width / 2 ,
                y: 0,
                width: atlas.textureRect().width / 2,
                height: atlas.textureRect().height)
            let texture = SKTexture(rect: rect, in: atlas)
            fieldTextures.append(texture)
        }
        
        
    }
}
    // MARK: - Block

extension TextureBank {
    func makeBlockTexture(){
        let atlass = SKTexture(imageNamed: "block")
//        for i in 0..<7 {
//            let rect = CGRect(
//                x: CGFloat(i) * atlass.textureRect().width / 7 ,
//                y: 0,
//                width: atlass.textureRect().width / 7,
//                height: atlass.textureRect().height)
//            let texture = SKTexture(rect: rect, in: atlass)
            blockTextures.append(atlass)
//        }
    }
}


// MARK: - Towers
extension TextureBank{
    func makeTowerTextures(){
        let atlass = SKTexture(imageNamed: "tower_prototype")
        for i in 0..<4 {
            let rect = CGRect(
                x: CGFloat(i) * atlass.textureRect().width / 4 ,
                y: 0,
                width: atlass.textureRect().width / 4,
                height: atlass.textureRect().height)
            let texture = SKTexture(rect: rect, in: atlass)
            towerTextures.append(texture)
        }
    }
}
// MARK: - Monsters
extension TextureBank{
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

// MARK: - Helper
extension TextureBank{
    func makeTexturesForHeight(_ h: Int,
                               countX: Int,
                               countY: Int,
                               name: String = "") -> [SKTexture]{
        let atlas = SKTexture(imageNamed: name)
        var result: [SKTexture] = []
        for i in 0..<countX {
            let rect = CGRect(x: CGFloat(i) * atlas.textureRect().width / CGFloat(countX) ,
                              y: CGFloat(h) * atlas.textureRect().height / CGFloat(countY),
                              width: atlas.textureRect().width / CGFloat(countX),
                              height: atlas.textureRect().height / CGFloat(countY))
            let texture = SKTexture(rect: rect, in: atlas)
            result.append(texture)
        }
        return result
    }
}
