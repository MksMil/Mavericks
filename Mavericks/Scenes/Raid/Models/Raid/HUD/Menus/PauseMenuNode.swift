import SpriteKit

class PauseMenuNode: SKNode{
    weak var outputDelegate: HudNode?
    let bank: RaidDataSource
    let sceneSize: CGSize
    
    let globalBgNode: SKSpriteNode
    let menuBgNode: SKSpriteNode
    //buttons?
    
    weak var tappedNode: SKNode?
    
    let tapAction: SKAction = SKAction.scale(to: 1.1, duration: 0.1)
    let untapAction: SKAction = SKAction.scale(to: 1, duration: 0.1)
    
    init(sceneSize: CGSize,bank: RaidDataSource) {
        self.sceneSize = sceneSize
        self.bank = bank
        self.globalBgNode = SKSpriteNode(color: NSColor.black,
                                         size: sceneSize)
        self.menuBgNode = SKSpriteNode(color: NSColor.white,
                                       size: CGSize(width: 200,
                                                    height: 300))
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit{
        print("pause menu deinit")
    }
}
// MARK: - Setup
extension PauseMenuNode {
    func setup(){
    setupGlobalBg()
    setupMenu()
    setupButtons()
    makeInitialStateForMenu()
}
    func setupGlobalBg(){
        globalBgNode.position = CGPoint(x: sceneSize.width / 2,
                                        y: sceneSize.height / 2)
        addChild(globalBgNode)
    }
    func setupMenu(){
        menuBgNode.position = CGPoint(x: sceneSize.width / 2,
                                      y: sceneSize.height / 2)
        addChild(menuBgNode)
    }
    func setupButtons(){
        let menuTextures = bank.pauseMenuTextures
        for i in 0 ..< menuTextures.count{
            let buttonNode = HudButton(texture: menuTextures[i])
            buttonNode.isUserInteractionEnabled = false
            switch i {
                case 0:
                    buttonNode.name = NodeNames.resume.rawValue
                case 1:
                    buttonNode.name = NodeNames.restart.rawValue
                case 2:
                    buttonNode.name = NodeNames.options.rawValue
                case 3:
                    buttonNode.name = NodeNames.exit.rawValue
                    
                default:
                    buttonNode.name = NodeNames.empty.rawValue
            }
            menuBgNode.addChild(buttonNode)
            buttonNode.position = CGPoint(x: 0,
                                          y: Int(menuBgNode.size.height / 3) - (i * 64) )
        }
    }
    
    func makeInitialStateForMenu(){
        globalBgNode.alpha = 0
        menuBgNode.alpha = 0
        menuBgNode.setScale(0)
    }

}

// MARK: - Animations
extension PauseMenuNode{
    func show() {
        print("show called")
        globalBgNode.removeAllActions()
        menuBgNode.removeAllActions()
        globalBgNode.run(.fadeAlpha(to: 0.3, duration: 0.2))
        menuBgNode.run(.group([.scale(to: 1.0, duration: 0.3),
                               .fadeAlpha(to: 0.7, duration: 0.3)]))
    }

    func hide() {
        globalBgNode.removeAllActions()
        menuBgNode.removeAllActions()
        tappedNode = nil
        globalBgNode.run(.fadeAlpha(to: 0.0, duration: 0.2))
        menuBgNode.run(.group([.scale(to: 0.0, duration: 0.3),
                               .fadeAlpha(to: 0.0, duration: 0.3)]))
    }
}

// MARK: - Event Handling
extension PauseMenuNode {
    func buttonNode(node: SKNode, tapped: Bool) {
        guard let name = node.name,
              [NodeNames.resume, .restart, .options, .exit].map({ $0.rawValue }).contains(name)
        else {
            tappedNode?.run(untapAction)
            return
        }

        if tapped { tappedNode = node }
        
        node.run(tapped ? tapAction : untapAction) { [weak self] in
            guard let self = self, !tapped else { return }
            self.tappedNode = nil

            self.hide()
            if name == NodeNames.resume.rawValue {
                self.outputDelegate?.changeState(newState: .run)
            } else if name == NodeNames.exit.rawValue {
                self.outputDelegate?.changeState(newState: .finishRaid)
            }
        }    }
}
// MARK: - ControlInputDelegate
extension PauseMenuNode: ControlInputDelegate {
    func handleMouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        if let tappedNode = nodes(at: location).first{
            buttonNode(node: tappedNode, tapped: true)
        }
    }
    
    func handleMouseUp(with event: NSEvent) {
        let location = event.location(in: self)
        if let tappedNode = nodes(at: location).first{
            buttonNode(node: tappedNode, tapped: false)
        }
    }
    func handleScrollWheel(with event: NSEvent) {}
    func handleMagnify(with event: NSEvent) {}
    func handleRotate(with event: NSEvent) {}
    func handleMouseMoved(with event: NSEvent) {}
    func handlePressureChange(with event: NSEvent) {}
    func handleKeyUp(with event: NSEvent) {}
    func handleKeyDown(with event: NSEvent) {}
}
