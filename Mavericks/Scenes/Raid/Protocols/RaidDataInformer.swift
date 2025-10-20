import Foundation

//hud process


protocol RaidDataInformer {
    var controlDelegate: ControlInputDelegate? { get set}
    var bank: RaidDataSource? {get set}
    
    func showMenu(inPosition: CGPoint)
    func showInfo(contentOwner: Informable)
    func showPauseMenu()
    func hidePauseMenu()
    func hideMenu()
}
