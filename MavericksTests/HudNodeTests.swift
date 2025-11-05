import XCTest
import SpriteKit
@testable import Mavericks

@MainActor
final class HudNodeTests: XCTestCase {
    
    var scene: RaidScene!
    var hud: HudNode!
    
    override func setUp() {
        super.setUp()
        scene = TestHelper.setupSKView()
        hud = HudNode(withCameraSize: .zero,
                      bank: TestHelper.mockBank)
        scene.cameraNode.addChild(hud)
    }
    
    override func tearDown() {
        scene = nil
        hud = nil
        super.tearDown()
    }
    // MARK: - Setup
//    func testSetup_CreatesPauseButton() {
//        let scene = setupSKView()
//        let hud = HudNode(withCameraSize: .zero, bank: mockBank, outputDelegate: scene)
//        
//        XCTAssertNotNil(hud.pauseButton)
//        XCTAssertEqual(hud.pauseButton.name, NodeNames.pauseButton.rawValue)
//        XCTAssertTrue(hud.children.contains(hud.pauseButton))
//    }
    
    func testSetup_CreatesPauseMenu() {
        XCTAssertNotNil(hud.pauseMenu)
        XCTAssertTrue(hud.children.contains(where: { $0 === hud.pauseMenu }))
    }
    
    // MARK: - Menu Animations
    func testShowMenu_AnimatesPauseMenu() async {
        hud.showPauseMenu()
        let menu = hud.pauseMenu
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(menu.globalBgNode.alpha, 0.3, accuracy: 0.01)
        XCTAssertEqual(menu.menuBgNode.alpha, 0.7, accuracy: 0.01)
        XCTAssertEqual(menu.menuBgNode.xScale, 1.0, accuracy: 0.01)
    }
    
    func testHideMenu_AnimatesPauseMenu() async {
        
        let menu = hud.pauseMenu
        XCTAssertEqual(menu.globalBgNode.alpha, 0.0, accuracy: 0.01)
        XCTAssertEqual(menu.menuBgNode.alpha, 0.0, accuracy: 0.01)
        XCTAssertEqual(menu.menuBgNode.xScale, 0.0, accuracy: 0.01)
        hud.showPauseMenu()
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        XCTAssertEqual(menu.globalBgNode.alpha, 0.3, accuracy: 0.01)
        XCTAssertEqual(menu.menuBgNode.alpha, 0.7, accuracy: 0.01)
        XCTAssertEqual(menu.menuBgNode.xScale, 1.0, accuracy: 0.01)
        hud.hidePauseMenu()
        try? await Task.sleep(nanoseconds: 1500_000_000)
        XCTAssertEqual(menu.globalBgNode.alpha, 0.0, accuracy: 0.01)
        XCTAssertEqual(menu.menuBgNode.alpha, 0.0, accuracy: 0.01)
        XCTAssertEqual(menu.menuBgNode.xScale, 0.0, accuracy: 0.01)

    }
    
    // MARK: - Button Interaction
    func testPauseButton_Tap_ShowsMenu() async {
        hud.showPauseMenu()
        try? await Task.sleep(nanoseconds: 500_000_000)
        let menu = hud.pauseMenu
        XCTAssertEqual(menu.globalBgNode.alpha, 0.3, accuracy: 0.01)
    }
    
    // MARK: - State Change
    func testChangeState_Pause_ShowsMenu() async {
        hud.showPauseMenu()
        try? await Task.sleep(nanoseconds: 500_000_000)
        let menu = hud.pauseMenu
        XCTAssertEqual(menu.globalBgNode.alpha, 0.3, accuracy: 0.01)
    }
    
    func testChangeState_Run_HidesMenu() async {
        let scene = TestHelper.setupSKView()
        let hud = HudNode(withCameraSize: scene.size,
                          bank: TestHelper.mockBank)
        scene.cameraNode.addChild(hud)
        hud.showPauseMenu() // Сначала показываем
                
        try? await Task.sleep(nanoseconds: 1000_000_000)
        
        hud.hidePauseMenu()
        
        try? await Task.sleep(nanoseconds: 1000_000_000)
        
        let menu = hud.pauseMenu
        XCTAssertEqual(menu.globalBgNode.alpha, 0.0, accuracy: 0.01)
        
    }
    
    // MARK: - Deinit
    func testDeinit_CalledWhenRemoved() {
        var strongRef: HudNode? = HudNode(withCameraSize: .zero,
                                          bank: TestHelper.mockBank)
        weak var weakRef = strongRef
        strongRef = nil
        XCTAssertNil(weakRef)
    }
}

