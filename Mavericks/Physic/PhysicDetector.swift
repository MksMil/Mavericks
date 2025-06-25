import SpriteKit

class PhysicDetector: NSObject, SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        //using contactNormal we can depend where collision was made
        // dy ==  1: down,
        // dy == -1: up,
        // dx ==  1: left,
        // dx == -1: right
        let collision =
            contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        let normal = contact.contactNormal

        //        if contact.bodyA.categoryBitMask == PhysicsCategory.Player || contact.bodyB.categoryBitMask == PhysicsCategory.Player{
        //            let contactBody = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB:contact.bodyA
        //        }

        //        if normal.dy > 0, mainHeroNode.verticalMoveState != .onGround{
        ////            print("begin coll")
        //            mainHeroNode.verticalMoveState = .onGround
        //            mainHeroNode.endJumpValue = Date.now
        ////            print("dif: \(mainHeroNode.startJumpValue.timeIntervalSince1970 - mainHeroNode.endJumpValue.timeIntervalSince1970)")
        //            if collision == (PhysicsCategory.Player | PhysicsCategory.Obstacle){
        //                mainHeroNode.stopMoving()
        //            } else if collision == (PhysicsCategory.Player | PhysicsCategory.Edges){
        //                mainHeroNode.stopMoving()
        //            }
        //        } else {
        //            mainHeroNode.acceptCompenstionVelosity(compenstionVelocity: normal)
        //        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        let collision =
            contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        let normal = contact.contactNormal
        let impulse = contact.collisionImpulse

    }
}
