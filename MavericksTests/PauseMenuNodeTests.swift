import XCTest
import SpriteKit
@testable import Mavericks

@MainActor
final class PauseMenuNodeTests: XCTestCase {
    
    var sut: PauseMenuNode!
    
    // MARK: - Setup
    override  func setUp() {
        sut = PauseMenuNode(sceneSize: CGSize(width: 800,
                                              height: 600),
                            bank: TestHelper.mockBank)
        
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testSetup_CreatesCorrectNumberOfButtons() {
        let buttonCount = sut.menuBgNode.children.count
        XCTAssertEqual(buttonCount, 4)
    }

    func testSetup_ButtonsHaveCorrectNames() {
        let buttonNames = sut.menuBgNode.children.compactMap { ($0 as? HudButton)?.name }
        XCTAssertEqual(buttonNames,
                       [NodeNames.resume.rawValue,
                        NodeNames.restart.rawValue,
                        NodeNames.options.rawValue,
                        NodeNames.exit.rawValue
                       ])
    }

    // MARK: - Animations
    func test_show_AnimatesCorrectly() async {
        let scene = TestHelper.setupSKView()
        scene.addChild(sut)
        sut.show()
        try? await Task.sleep(nanoseconds: 500_000_000)
        XCTAssertEqual(sut.globalBgNode.alpha, 0.3, accuracy: 0.01)
        XCTAssertEqual(sut.menuBgNode.alpha, 0.7, accuracy: 0.01)
        XCTAssertEqual(sut.menuBgNode.xScale, 1.0, accuracy: 0.01)
    }

    func testHide_AnimatesCorrectly() async {
        let scene = TestHelper.setupSKView()
        let mockHudNode = MockHudNode(bank: TestHelper.mockBank,
                                      delegate: scene)
        scene.hudNode = mockHudNode
        scene.camera?.addChild(mockHudNode)
        sut.outputDelegate = mockHudNode
        mockHudNode.pauseMenu = sut
        mockHudNode.addChild(sut)
        try? await Task.sleep(nanoseconds: 500_000_000)
        sut.show()
        try? await Task.sleep(nanoseconds: 500_000_000)
        XCTAssertEqual(sut.globalBgNode.alpha, 0.3, accuracy: 0.01)
        XCTAssertEqual(sut.menuBgNode.alpha, 0.7, accuracy: 0.01)
        XCTAssertEqual(sut.menuBgNode.xScale, 1.0, accuracy: 0.01)
        sut.hide()
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        XCTAssertEqual(sut.globalBgNode.alpha, 0.0, accuracy: 0.01)
        XCTAssertEqual(sut.menuBgNode.alpha, 0.0, accuracy: 0.01)
        XCTAssertEqual(sut.menuBgNode.xScale, 0.0, accuracy: 0.01)
        XCTAssertEqual(sut.menuBgNode.yScale, 0.0, accuracy: 0.01)
    }

    func testButtonNode_ExitButton_FinishesRaid() async {
        let scene = TestHelper.setupSKView()
        let mockHudNode = MockHudNode(bank: TestHelper.mockBank,
                                      delegate: scene)
        scene.hudNode = mockHudNode
        scene.camera?.addChild(mockHudNode)
        
        sut.outputDelegate = mockHudNode
        mockHudNode.pauseMenu = sut
        mockHudNode.addChild(sut)
        
        let exitButton = sut.menuBgNode.children.last {
            ($0 as? HudButton)?.name == NodeNames.exit.rawValue
        } as? HudButton
        sut.buttonNode(node: exitButton!, tapped: false)
        try? await Task.sleep(nanoseconds: 500_000_000)
        XCTAssertTrue(mockHudNode.changeStateFinishRaidCalled)
            
    }

    // MARK: - Deinit
    func testDeinit_CalledWhenRemoved() {
        var strongRef: PauseMenuNode? = PauseMenuNode(sceneSize: .zero,
                                                      bank: TestHelper.mockBank)
        weak var weakRef = strongRef
        XCTAssertNotNil(weakRef)
        strongRef = nil
        XCTAssertNil(weakRef)  // deinit
    }
}

