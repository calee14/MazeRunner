//
//  Maze.swift
//  MazeRunner
//
//  Created by Cappillen on 7/7/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import Foundation

class Maze: SKScene, SKPhysicsContactDelegate {
    
    var runner: Runner!
    var dir: Direction = .still
    var cameraNode: SKCameraNode!
    var cameraTarget: Runner?
    var spd: CGFloat = 4
    var startPoint: CGPoint!
    var trackingTimer: Bool = false
    var timer: Float!
    var timerLabel: SKLabelNode!
    var gameState: GameState = .still
    
    override func didMove(to view: SKView) {
        
        //Declaring swipe gestures
        //Creating the Swipe Right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameScene().swiped(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRight)
        //Creating the Swipe Down
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(GameScene().swiped(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(swipeDown)
        //Creating the SwipeUp
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(GameScene().swiped(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view?.addGestureRecognizer(swipeUp)
        //Creating the SwipeLeft
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameScene().swiped(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeft)
        
        gameState = .firstSwipe
        
        //Creates a border the size of the frame
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        
        //self.physicsBody = border
        
        physicsWorld.contactDelegate = self
        
        //Connect spaceShip recursive search\
        runner = childNode(withName: "runner") as! Runner
        startPoint = runner.position
        
        //Connect the camera node
        cameraNode = self.childNode(withName: "cameraNode") as! SKCameraNode
        self.camera = cameraNode
        cameraTarget = runner
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveCamera()
        
        //Check direction
        runner.checkDirection()
        }
    
    func didBegin(_ contact: SKPhysicsContact) {
    
    }
    
    func moveCamera() {
        //moves the camera to follow the player
        guard let cameraTarget = cameraTarget else {
            return
        }
        //Clamping the x and y values
        let targetX = cameraTarget.position.x
        let x = clamp(value: targetX, lower: 0, upper: 100000)
        cameraNode.position.x = x
        let targetY = cameraTarget.position.y
        let y = clamp(value: targetY, lower: 0, upper: 130000)
        cameraNode.position.y = y
    }
    
    func swiped(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            //Does the swipe check
            //Switch function if the player swiped up, down, left, right
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                runner.dir = .right
            case UISwipeGestureRecognizerDirection.down:
                runner.dir = .down
            case UISwipeGestureRecognizerDirection.left:
                runner.dir = .left
            case UISwipeGestureRecognizerDirection.up:
                runner.dir = .up
            default:
                break
            }
        }
    }
}
