//
//  GameScene.swift
//  MazeRunner
//
//  Created by Cappillen on 7/4/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

enum Direction {
    case up, down, right, left, still
}

enum GameState {
    case still, firstSwipe, playing, exit
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
    var startTime = TimeInterval()
    var fastestTime: Float!
    var pointer: SKSpriteNode!
    var exit: SKSpriteNode!
    
    //Bouncers
    var bouncer: [Bouncer] = []
    var bouncer1: Bouncer!
    var bouncer2: Bouncer!
    var bouncer3: Bouncer!
    var bouncer4: Bouncer!
    var bouncer5: Bouncer!
    var bouncer6: Bouncer!
    var bouncer7: Bouncer!
    var bouncer8: Bouncer!
    
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
        
        //Gets the starting time for the timer
        trackingTimer = false
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
        //Connect the label nodes
        timerLabel = self.childNode(withName: "//timerLabel") as! SKLabelNode
        //Pointer 
        pointer = self.childNode(withName: "//pointer") as! SKSpriteNode
        //Get the exit so we can use the position
        exit = self.childNode(withName: "exit") as! SKSpriteNode
        
        //Defaults
        let timerDefault = UserDefaults.standard
        
        if timerDefault.float(forKey: "highscore") != 0 {
            fastestTime = timerDefault.float(forKey: "highscore")
        } else {
            fastestTime = 0.0
        }
        print(fastestTime)
        print(timer)
        
        //Connect bouncers
        bouncer1 = self.childNode(withName: "bouncer1") as! Bouncer
        bouncer1.direction = .hor
        bouncer.append(bouncer1)
        bouncer2 = self.childNode(withName: "bouncer2") as! Bouncer
        bouncer2.direction = .hor
        bouncer.append(bouncer2)
        bouncer3 = self.childNode(withName: "bouncer3") as! Bouncer
        bouncer3.direction = .hor
        bouncer.append(bouncer3)
        bouncer4 = self.childNode(withName: "bouncer4") as! Bouncer
        bouncer4.direction = .vert
        bouncer.append(bouncer4)
        bouncer5 = self.childNode(withName: "bouncer5") as! Bouncer
        bouncer5.direction = .hor
        bouncer.append(bouncer5)
        bouncer6 = self.childNode(withName: "bouncer6") as! Bouncer
        bouncer6.direction = .hor
        bouncer.append(bouncer6)
        bouncer7 = self.childNode(withName: "bouncer7") as! Bouncer
        bouncer7.direction = .vert
        bouncer.append(bouncer7)
        bouncer8 = self.childNode(withName: "bouncer8") as! Bouncer
        bouncer8.direction = .hor
        bouncer.append(bouncer8)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveCamera()
        movePointer()
        
        //Check direction
        runner.checkDirection()
        
        //Moves the bouncers
        for node in bouncer {
            node.moveBouncer()
        }
        if trackingTimer == true {
            //Update timer
            updateTime()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        let nodeA = contactA.node
        let nodeB = contactB.node
        
        //Check if the bouncers are colliding with anything and if so switch direction
        if nodeA?.physicsBody?.contactTestBitMask == 2 {
            guard let bounce = nodeA as! Bouncer! else {
                return
            }
            bounce.switchDirection()
        } else if nodeB?.physicsBody?.contactTestBitMask == 2 {
            guard let bounce = nodeB as! Bouncer! else {
                return
            }
            bounce.switchDirection()
        }
        
        //Check if player is colliding with the wall
        if nodeA?.physicsBody?.contactTestBitMask == 1 && nodeB?.physicsBody?.contactTestBitMask == 0 {
            //dir = .still
        } else if nodeA?.physicsBody?.contactTestBitMask == 0 && nodeB?.physicsBody?.contactTestBitMask == 1 {
            //dir = .still
        }
        
        //Check if player is colliding with the bouncer
        if nodeA?.physicsBody?.contactTestBitMask == 2 && nodeB?.physicsBody?.contactTestBitMask == 1 {
            print("collided")
            let movePosition = SKAction.run({
                self.runner.position = self.startPoint
                self.runner.dir = .still
            })
            self.run(movePosition)
        } else if nodeA?.physicsBody?.contactTestBitMask == 1 && nodeB?.physicsBody?.contactTestBitMask == 2 {
            print("collided")
            let movePosition = SKAction.run({
                self.runner.position = self.startPoint
                self.runner.dir = .still
            })
            self.run(movePosition)
        }
        
        //Check if player has collided with the exit
        if nodeA?.physicsBody?.contactTestBitMask == 1 && nodeB?.physicsBody?.contactTestBitMask == 4 {
            print("we made it ")
            trackingTimer = false
            celebrate()
        } else if nodeA?.physicsBody?.contactTestBitMask == 4 && nodeB?.physicsBody?.contactTestBitMask == 1 {
            print("we made it")
            trackingTimer = false
            celebrate()
        }
    }
    
    func celebrate() {
        //Add a bokeh emmiter
        let celebration = SKEmitterNode(fileNamed: "Celebration")
        celebration?.position = CGPoint(x: runner.position.x - 20, y: runner.position.y)
        let celebration2 = SKEmitterNode(fileNamed: "Celebration")
        celebration2?.position = CGPoint(x: runner.position.x + 20, y: runner.position.y)
        let celebration3 = SKEmitterNode(fileNamed: "Celebration")
        celebration3?.position = CGPoint(x: runner.position.x , y: runner.position.y + 20)
        let celebration4 = SKEmitterNode(fileNamed: "Celebration")
        celebration4?.position = CGPoint(x: runner.position.x , y: runner.position.y - 30)
        addChild(celebration!)
        addChild(celebration2!)
        addChild(celebration3!)
        addChild(celebration4!)
        
        //Check if the time is faster than the best
        if timer > fastestTime {
            let timerDefault = UserDefaults.standard
            timerDefault.set(timer, forKey: "highscore")
        }
        //change the game scene to exit 
        gameState = .exit
        
        //highscoreLabel.text = String("Highscore: \(fastestTime)")
        print(fastestTime)
    }
    
    func moveCamera() {
        guard let cameraTarget = cameraTarget else {
            return
        }
        let targetX = cameraTarget.position.x
        let x = clamp(value: targetX, lower: 0, upper: 1300)
        cameraNode.position.x = x
        let targetY = cameraTarget.position.y
        let y = clamp(value: targetY, lower: 0, upper: 1300)
        cameraNode.position.y = y
    }
    
    func movePointer() {
        guard let pointerTarget = cameraTarget else {
            return
        }
        let targetX = pointerTarget.position.x
        let x = clamp(value: targetX, lower: 0, upper: 1300)
        pointer.position.x = x
        let targetY = pointerTarget.position.y
        let y = clamp(value: targetY, lower: 0, upper: 1300)
        pointer.position.y = y
        
        if gameState != .exit {
            pointer.rotateVersus(destPoint: exit.position)
        } else {
            pointer.removeFromParent()
        }
    }

    func swiped(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            checkFirstSwipe()
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
    
    func checkFirstSwipe() {
        if gameState == .firstSwipe {
            if trackingTimer != true {
                trackingTimer = true
                startTime = NSDate.timeIntervalSinceReferenceDate
                gameState = .playing
            } else {
                return
            }
        }
    }
    
    func calculateTime() {
        //Get the elasped time passed
        var elaspedTime: TimeInterval = TimeInterval(timer)
        
        //Get the hours
        let hours = UInt8(elaspedTime / 3600)
        
        //Get the minutes 
        let minutes = UInt8(elaspedTime / 60.0)
        elaspedTime -= (TimeInterval(minutes) * 60)
        //Get the seconds
        let seconds = UInt8(elaspedTime)
        elaspedTime -= TimeInterval(seconds)
        
        //Find the fraction of the second
        let fraction = UInt8(elaspedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        let time = ("\(strHours):\(strMinutes):\(strSeconds):\(strFraction)")
    }
    
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        
        var elapsedTime: TimeInterval = currentTime - startTime
        
        //calculate the hours in elasped time
        let hours = UInt8(elapsedTime / 3600)
        
        //calculate the minutes in elapsed time.
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        let time = ("\(strHours):\(strMinutes):\(strSeconds):\(strFraction)")
        timerLabel.text = time
        timer = Float(fraction)
        print(timer)
        
    }
}

func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
}
