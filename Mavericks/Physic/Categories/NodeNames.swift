// Naming for nodes

enum NodeNames: String{
    case camera, bg, startButton
    case buttonLeft, buttonRight, buttonUp, buttonDown, buttonA, buttonB, buttonPauseResume, buttonSpecail
    case labelScores, labelLives
    case mainHero
    case empty
    
    var name: String {
        self.rawValue
    }
}
