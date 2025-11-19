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

enum GraphicsQuality {
    case low, medium, high
}

final class TextureBank: RaidDataSource {
    //quality change for future
    var quality: GraphicsQuality = .high
    private var suffix: String {
        switch quality {
            case .low: return "_sd"
            case .medium: return "_md"
            case .high: return ""
        }
    }
    //
    
    //atlases
    var mapAtlas: SKTextureAtlas
    var contentAtlas: SKTextureAtlas
    var interactiveAtlas: SKTextureAtlas
    var hudAtlas: SKTextureAtlas
    //
    init() {
        self.mapAtlas = SKTextureAtlas(named: "map")
        self.contentAtlas = SKTextureAtlas(named: "content")
        self.interactiveAtlas = SKTextureAtlas(named: "interactive")
        self.hudAtlas = SKTextureAtlas(named: "hud")
    }
        
    func preload(completion: @escaping () -> Void) {
        Task { @MainActor in
            do{
                let _ = try await self.preload()
                completion()
            } catch {
                print("cant preload texture atlases")
            }
        }
    }
    func preload() async throws -> Double {
        let atlases = [mapAtlas, contentAtlas, hudAtlas, interactiveAtlas]
        var completed = 0
        let total = atlases.count
        
        await withTaskGroup(of: Void.self) { group in
            for atlas in atlases {
                group.addTask { @MainActor in
                    await atlas.preload()
                    completed += 1
                    let progress = Double(completed) / Double(total)
                    print("Загрузка атласов: \(Int(progress * 100))%")
                    // Здесь можно обновить UI
                }
            }
            await group.waitForAll()
        }
        return 1.0
    }
        
        // MARK: - Безопасный доступ
//        
//        var monsterGoblinIdle: [SKTexture] {
//            (0...7).map { monsters.textureNamed("goblin_idle_\($0)") }
//        }
//        
//        var tileGrass: SKTexture { tiles.textureNamed("grass_0") }
//        var buttonPlay: SKTexture { ui.textureNamed("btn_play") }
//    
//    var towerArrow: SKTexture {
//        towers.textureNamed("tower_arrow\(suffix)")
//    }
}

// 2. Кэширование анимированных текстур
private var cachedAnimations: [String: [SKTexture]] = [:]

func animation(for key: String,
               prefix: String,
               count: Int) -> [SKTexture] {
    if let cached = cachedAnimations[key] { return cached }
    
//    let frames = (0..<count).map { monsters.textureNamed("\(prefix)_\($0)") }
//    cachedAnimations[key] = frames
//    return frames
    return []
}
