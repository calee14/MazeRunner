//
//  Bouncers.swift
//  MazeRunner
//
//  Created by Cappillen on 7/5/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit

enum Side {
    case up, down, none
}

enum Axis {
    case hor, vert, none
}
class Bouncer: SKSpriteNode{
    
    var spd: CGFloat = 4
    var direction: Axis = .none
    
    func switchDirection() {
        spd *= -1
    }
    
    func moveBouncer() {
        if direction == .hor {
            self.position.x += spd
        } else if direction == .vert {
            self.position.y += spd
        } else {
            return
        }
    }
    
    //You are required to implement this for your subclass to work
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    //Your are required to implement this for your subclass to work
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
