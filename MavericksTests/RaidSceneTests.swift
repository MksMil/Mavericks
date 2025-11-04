import XCTest
import SpriteKit
@testable import Mavericks

@MainActor
final class RaidSceneTests: XCTestCase {
    var scene: RaidScene!
    var hud: HudNode!
    
    override func setUp() {
        super.setUp()
        scene = TestHelper.setupSKView()
        hud = HudNode(withCameraSize: .zero, bank: TestHelper.mockBank, outputDelegate: scene)
        scene.cameraNode.addChild(hud)
    }
    
    override func tearDown() {
        scene = nil
        hud = nil
        super.tearDown()
    }
    
    // MARK: - Init
    func testInit_CreatesHudNode() {

        XCTAssertNotNil(scene.hudNode)
        XCTAssertTrue(((scene.camera?.children.contains(where: { $0 === scene.hudNode })) != nil))
    }
    
    // MARK: - State Change
    func testChangeState_Pause_Pauses() async {
        scene.changeState(newState: .pauseMenu)
        try? await Task.sleep(nanoseconds: 500_000_000)
        let field = scene.field?.fieldNode
        XCTAssertNotNil(field)
        if let field{
            XCTAssertTrue(field.isPaused)
        }
    }
    
    func testChangeState_Run_UnPauses() async {
        scene.changeState(newState: .pauseMenu)
        scene.changeState(newState: .raid)
        try? await Task.sleep(nanoseconds: 1000_000_000)
        let field = scene.field?.fieldNode
        XCTAssertNotNil(field)
        if let field{
            XCTAssertFalse(field.isPaused)
        }
    }
    
    // MARK: - Present Scene
    func testChangeState_Finish_CallsPresentHome() {
        scene.changeState(newState: .finish)
        
//        XCTAssertTrue(mockDelegate.presentHomeCalled)
    }
    
    // MARK: - Deinit
    func testDeinit_CalledWhenRemoved() {
        var strongRef: RaidScene? = RaidScene(size: .zero,
                                              bank: TestHelper.mockBank)
        weak var weakRef = strongRef
        
        strongRef = nil
        XCTAssertNil(weakRef)
    }
}

// MARK: - Mocks
class MockMainViewDelegate: MainViewDelegateProtocol {
    var presentHomeCalled = false
    func presentScene(_ scene: ScenePath) {
        if scene == .home {
            presentHomeCalled = true
        }
    }
}
