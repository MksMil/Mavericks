//  Created by Миляев Максим on 04.03.2025.
//
// protocol for define functionality to route behind scenes

import Foundation

protocol MainViewDelegateProtocol: AnyObject {
    func presentScene(_ scene: ScenePath)
}
