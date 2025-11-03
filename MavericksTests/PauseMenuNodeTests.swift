import XCTest
import SpriteKit
@testable import Mavericks

final class PauseMenuNodeTests: XCTestCase {
    let mockBank = TextureBank(levelInfo: "", cellSize: 64)
    // MARK: - Setup
    
    func testSetup_CreatesCorrectNumberOfButtons() {
        let pauseMenu = PauseMenuNode(sceneSize: CGSize(width: 800,
                                                        height: 600),
                                      bank: mockBank)
        let buttonCount = pauseMenu.menuBgNode.children.count
        XCTAssertEqual(buttonCount, 4)
    }

    func testSetup_ButtonsHaveCorrectNames() {
        let pauseMenu = PauseMenuNode(sceneSize: .zero, bank: mockBank)
        let buttonNames = pauseMenu.menuBgNode.children.compactMap { ($0 as? HudButton)?.name }
        XCTAssertEqual(buttonNames,
                       [NodeNames.resume.rawValue,
                        NodeNames.restart.rawValue,
                        NodeNames.options.rawValue,
                        NodeNames.exit.rawValue
                       ])
    }

    // MARK: - Animations
    func test_show_AnimatesCorrectly() {
        let scene = setupSKView()
        let pauseMenu = PauseMenuNode(sceneSize: CGSize(width: 800,
                                                        height: 600),
                                      bank: mockBank)
        scene.addChild(pauseMenu)
        let showExp = expectation(description: "show completes")
        pauseMenu.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(pauseMenu.globalBgNode.alpha, 0.3, accuracy: 0.01)
            XCTAssertEqual(pauseMenu.menuBgNode.alpha, 0.7, accuracy: 0.01)
            XCTAssertEqual(pauseMenu.menuBgNode.xScale, 1.0, accuracy: 0.01)
            showExp.fulfill()
        }
        wait(for: [showExp], timeout: 1.5)
    }

    func testHide_AnimatesCorrectly() {
        let scene = setupSKView()
        let pauseMenu = PauseMenuNode(sceneSize: CGSize(width: 800,
                                                        height: 600),
                                      bank: mockBank)
        scene.addChild(pauseMenu)
        let hideExp = expectation(description: "hide called")
        let showExp = expectation(description: "show completes")
        pauseMenu.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(pauseMenu.globalBgNode.alpha, 0.3, accuracy: 0.01)
            XCTAssertEqual(pauseMenu.menuBgNode.alpha, 0.7, accuracy: 0.01)
            XCTAssertEqual(pauseMenu.menuBgNode.xScale, 1.0, accuracy: 0.01)
            showExp.fulfill()
            pauseMenu.hide()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertEqual(pauseMenu.globalBgNode.alpha, 0.0, accuracy: 0.01)
            XCTAssertEqual(pauseMenu.menuBgNode.alpha, 0.0, accuracy: 0.01)
            XCTAssertEqual(pauseMenu.menuBgNode.xScale, 0.0, accuracy: 0.01)
            XCTAssertEqual(pauseMenu.menuBgNode.yScale, 0.0, accuracy: 0.01)
            hideExp.fulfill()
        }
        wait(for: [showExp,hideExp], timeout: 2)
    }

    // MARK: - Button handling
    func testButtonNode_ResumeButton_Unpauses() {
        let scene = setupSKView()
        let mockHudNode = MockHudNode(bank: mockBank,
                                      delegate: scene)
        scene.hudNode = mockHudNode
        scene.cameraNode.addChild(mockHudNode)
        let pauseMenu = PauseMenuNode(sceneSize: .zero,
                                      bank: mockBank)
        pauseMenu.outputDelegate = mockHudNode
        mockHudNode.pauseMenu = pauseMenu
        mockHudNode.addChild(pauseMenu)
        let resumeButton = pauseMenu.menuBgNode.children.first {
            ($0 as? HudButton)?.name == NodeNames.resume.rawValue 
        } as? HudButton
        let exp = expectation(description: "run called")
        pauseMenu.buttonNode(node: resumeButton!, tapped: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            XCTAssertTrue(mockHudNode.changeStateRunCalled)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }

    func testButtonNode_ExitButton_FinishesRaid() {
        let scene = setupSKView()
        let mockHudNode = MockHudNode(bank: mockBank,
                                      delegate: scene)
        scene.hudNode = mockHudNode
        scene.cameraNode.addChild(mockHudNode)
        let pauseMenu = PauseMenuNode(sceneSize: .zero,
                                      bank: mockBank)
        pauseMenu.outputDelegate = mockHudNode
        mockHudNode.pauseMenu = pauseMenu
        mockHudNode.addChild(pauseMenu)
        let exp = expectation(description: "exit called")
        let exitButton = pauseMenu.menuBgNode.children.last {
            ($0 as? HudButton)?.name == NodeNames.exit.rawValue 
        } as? HudButton
        pauseMenu.buttonNode(node: exitButton!, tapped: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            XCTAssertTrue(mockHudNode.changeStateFinishRaidCalled)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }

    // MARK: - Deinit
    func testDeinit_CalledWhenRemoved() {
        var strongRef: PauseMenuNode? = PauseMenuNode(sceneSize: .zero,
                                                      bank: mockBank)
        weak var weakRef = strongRef
        XCTAssertNotNil(weakRef)
        strongRef = nil
        XCTAssertNil(weakRef)  // deinit
    }
}

// MARK: - Mocks
class MockHudNode: HudNode {
    var changeStateRunCalled = false
    var changeStateFinishRaidCalled = false
    
    init(bank: RaidDataSource,
         delegate: RaidScene) {
        super.init(withCameraSize: .zero,
                   bank: bank,
                   outputDelegate: delegate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func changeState(newState: HudState) {
        switch newState {
        case .run:
            changeStateRunCalled = true
        case .finishRaid:
            changeStateFinishRaidCalled = true
        default:
            break
        }
    }
}

// MARK: - Helpers
extension PauseMenuNodeTests {
    func setupSKView() -> RaidScene {
        let window = NSWindow(
            contentRect: CGRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.makeKeyAndOrderFront(nil)
        let view = SKView(frame: window.contentView!.bounds)
        window.contentView!.addSubview(view)
        let scene = RaidScene(size: .zero,
                              bank: mockBank)
        view.presentScene(scene)
        return scene
    }
}
