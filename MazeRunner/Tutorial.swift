//
//  Tutorial.swift
//  MazeRunner
//
//  Created by Cappillen on 7/6/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class Tutorial: SKScene {
    
    var runner: Runner!
    var background: SKTileMapNode!
    
    override func didMove(to view: SKView) {
        
        //Declaring swipe gestures
        //Creating the Swipe Right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(Tutorial().swiped(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRight)
        //Creating the Swipe Down
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(Tutorial().swiped(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(swipeDown)
        //Creating the SwipeUp
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(Tutorial().swiped(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view?.addGestureRecognizer(swipeUp)
        //Creating the SwipeLeft
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(Tutorial().swiped(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeft)
        
        background = self.childNode(withName: "TileMapNode") as! SKTileMapNode
        runner = self.childNode(withName: "runner") as! Runner
        giveTileMapPhysicsBody(map: background)
    }
    
    override func update(_ currentTime: TimeInterval) {
        runner.checkDirection()
        print(runner.position)
    }

    
    func giveTileMapPhysicsBody(map: SKTileMapNode)
    {
        let tileMap = map
        
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        
        for col in 0..<tileMap.numberOfColumns {
            
            for row in 0..<tileMap.numberOfRows {
                
                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row)
                    
                {
                    //if tileDefinition == nil { return }
                    //let isEdgeTile = tileDefinition.userData?["AddBody"] as? Int  //uncomment this if needed, see article notes
                    //if (isEdgeTile != 0) {
                    let tileArray = tileDefinition.textures
                    let tileTexture = tileArray[0]
                    let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width/2)
                    let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height/2)
                    _ = CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height)
                    let tileNode = SKNode()
                    
                    tileNode.position = CGPoint(x: x, y: y)
                    tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, size: CGSize(width: (tileTexture.size().width * 2), height: (tileTexture.size().height * 2)))
                    tileNode.physicsBody?.linearDamping = 60.0
                    tileNode.physicsBody?.affectedByGravity = false
                    tileNode.physicsBody?.allowsRotation = false
                    tileNode.physicsBody?.restitution = 0.0
                    tileNode.physicsBody?.isDynamic = false
                    
                    
                    tileNode.physicsBody?.categoryBitMask = 4
                    
                    tileMap.addChild(tileNode)
                    //}
                }
            }
        }
    }
    
    func swiped(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            //Switch function if the player swiped up, down, left, right
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                runner.dir = .right
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                runner.dir = .down
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                runner.dir = .left
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                runner.dir = .up
            default:
                break
            }
        }
    }
}
