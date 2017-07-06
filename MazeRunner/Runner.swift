//
//  Runner.swift
//  MazeRunner
//
//  Created by Cappillen on 7/6/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit

class Runner: SKSpriteNode {
    
    var spd: CGFloat = 4
    var dir: Direction = .still
    
    func checkDirection() {
        if dir == .right {
            self.position.x += spd
        } else if dir == .left {
            self.position.x -= spd
        } else if dir == .up {
            self.position.y += spd
        } else if dir == .down {
            self.position.y -= spd
        } else if dir == .still {
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
