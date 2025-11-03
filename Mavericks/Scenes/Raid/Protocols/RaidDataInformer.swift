import Foundation
//hud process
protocol RaidDataInformer: AnyObject {
    var controlInputDelegate: ControlInputDelegate? {get set}
    var outputDelegate: RaidScene? {get set}
    
    func showMenu(inPosition: CGPoint)
    func showInfo(contentOwner: Informable)
    func hideMenu()
    
    func showPauseMenu()
    func hidePauseMenu()
    
    func changeState(newState: HudState)
}
