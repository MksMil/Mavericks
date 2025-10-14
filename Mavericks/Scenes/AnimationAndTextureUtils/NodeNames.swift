// Naming for nodes

enum NodeNames: String{
    case bg, startButton
    case buttonLeft, buttonRight, buttonUp, buttonDown, buttonA, buttonB, buttonPauseResume, buttonSpecail
    case labelScores, labelLives
    case mainHero
    case empty
    
    case camera = "cameraNode"
    case base = "base"
    case resource = "resource"
    case monsterSpawn = "monsterSpawn"
    case turret = "turret"
    case monster = "monster"
    case block = "block"
    
    
    var name: String {
        self.rawValue
    }
}
