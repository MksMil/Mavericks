import XCTest
import SpriteKit
@testable import Mavericks 

final class HudButtonTests: XCTestCase {

    func testSetup_SetsPropertiesCorrectly() {
        let button = HudButton()
        button.setup(withName: "pause", size: CGSize(width: 50, height: 50), position: CGPoint(x: 100, y: 200))
        
        XCTAssertEqual(button.textureName, "pause")
        XCTAssertEqual(button.size, CGSize(width: 50, height: 50))
        XCTAssertEqual(button.position, CGPoint(x: 100, y: 200))
        XCTAssertFalse(button.isUserInteractionEnabled)
        XCTAssertTrue(button.state)
    }

    func testDeinit_CalledWhenRemoved_WeakReference() {
        var strongRef: HudButton? = HudButton()
        weak var weakRef = strongRef
        XCTAssertNotNil(weakRef)
        strongRef?.setup(withName: "pause", size: .zero, position: .zero)
        strongRef = nil
        
        XCTAssertNil(weakRef)  // deinit вызван
    }
}
