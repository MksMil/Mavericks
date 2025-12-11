import Foundation

struct DamageModel {
    
    var physic: CGFloat
    var fire: CGFloat
    var chemic: CGFloat
    
    var full: CGFloat{
        physic + fire + chemic
    }
}
