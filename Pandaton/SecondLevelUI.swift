//
//  SecondLevelUI.swift
//  Pandaton
//
//  Created by vipul garg on 2020-06-16.
//  Copyright © 2020 VipulGarg. All rights reserved.
//

import SpriteKit
import GameplayKit

class SecondLevelUI : SKScene {
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let hero = SKSpriteNode(imageNamed: "hero")
    let background = SKSpriteNode(imageNamed: "bg")
    let spikes = SKSpriteNode(imageNamed: "spikes_new")
    let spikes2 = SKSpriteNode(imageNamed: "spikes_new")

    let coin = SKSpriteNode(imageNamed: "coin")
    let exit = SKSpriteNode(imageNamed: "exit2")
    
    let zombieMovePointsPerSec: CGFloat = 480.0
    var velocity = CGPoint.zero
    let playableRect: CGRect
    
    var dt: TimeInterval = 0
    let cameraNode = SKCameraNode()
    
    var lives = 3
    var level = 1
    var coinCollected = false
    var gameOver = false
    var exited = false
    
    let livesLabel = SKLabelNode(fontNamed: "Superclarendon-Black")
    let levelLabel = SKLabelNode(fontNamed: "Superclarendon-Black")
    
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin,
                          width: size.width,
                          height: playableHeight)
       
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func debugDrawPlayableArea() {
           let shape = SKShapeNode()
           let path = CGMutablePath()
           path.addRect(playableRect)
           shape.path = path
           shape.strokeColor = SKColor.red
           shape.lineWidth = 4.0
           addChild(shape)
          }
       
    
    override func didMove(to view: SKView) {
       self.debugDrawPlayableArea()
       let backgroundTexture = SKTexture(imageNamed: "bg")

       let background = SKSpriteNode(texture: backgroundTexture)
       background.zPosition = -1
        background.size = CGSize(width: self.frame.size.width  , height: self.frame.size.height * 0.8 )
       background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
       background.position = CGPoint(x:  size.width/2, y: size.height/2)
       addChild(background)
        
        spikes.position = CGPoint(x:  size.width/2  * 0.8, y: 310)
//        spikes.setScale(0.5)
        spikes.size = CGSize(width: 100  , height: 100 )
        spikes.name = "spikes"
        addChild(spikes)
        
        
        
        
        coin.position = CGPoint(x:  size.width/2, y: 400)
        coin.setScale(0.6)
        coin.name = "coin"
        addChild(coin)
        
        exit.position = CGPoint(x:  hero.size.width/2 , y: 340)
        exit.name  = "exit"
        exit.setScale(0)
        addChild(exit)
      
        spawnHero()
        
        addChild(cameraNode)
           camera = cameraNode
           cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
        
        livesLabel.text = "Lives: X"
         livesLabel.fontSize = 100
        livesLabel.zPosition = 150
         livesLabel.position = CGPoint(
                      x: playableRect.size.width - CGFloat(320),
                       y: playableRect.size.height - CGFloat(20))
                self.addChild(livesLabel)
        
        levelLabel.text = "Coins: X"
                levelLabel.fontSize = 100
               levelLabel.zPosition = 150
                levelLabel.position = CGPoint(
                             x:  CGFloat(320),
                              y: playableRect.size.height - CGFloat(20))
                       self.addChild(levelLabel)
        
    }
    
    func spawnHero() {
       
        hero.position = CGPoint(
          x: hero.size.width,
          y: 370)
        hero.zPosition = 50
        hero.name = "hero"
        addChild(hero)
        
        let actionMove =
          SKAction.moveBy(x: size.width, y: 0, duration: 2.0)
        let actionrught =
        SKAction.moveBy(x: -(size.width ), y: 0, duration: 2.0)
        hero.run(SKAction.repeatForever(SKAction.sequence([actionMove, actionrught])))


    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                       let location = touch.location(in: self)
                    print(location)
                let jumpUpAction = SKAction.moveBy(x: 0, y: 300, duration: 0.3)
                // move down 20
                let jumpDownAction = SKAction.moveBy(x: 0, y: -300, duration: 0.3)
                // sequence of move yup then down
                let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])

                // make player run sequence
                hero.run(jumpSequence)
//                moveZombieToward()
                }
        }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime > 0 {
             dt = currentTime - lastUpdateTime
           } else {
             dt = 0
           }
           lastUpdateTime = currentTime
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        
        // Update entities
        self.lastUpdateTime = currentTime
        
//        move(sprite: hero, velocity: velocity)
        boundsCheckZombie()
        
        livesLabel.text = "Lives: \(lives)"
        levelLabel.text = "L: \(level)"
        
    }
    
    override func didEvaluateActions() {
       checkCollisions()
     }
    
    
    
    func moveZombieToward() {
        let offset = CGPoint(x: frame.size.width, y: 0) - hero.position
        let direction = offset.normalized()
        velocity = direction * zombieMovePointsPerSec
    }
    
    func boundsCheckZombie() {
      let bottomLeft = CGPoint(x: playableRect.minX, y: playableRect.minY)
      let topRight = CGPoint(x: playableRect.maxX, y: playableRect.maxY)
      
      if hero.position.x <= bottomLeft.x {
        hero.position.x = bottomLeft.x
        velocity.x = abs(velocity.x)
      }
      if hero.position.x >= topRight.x {
        hero.position.x = topRight.x
        velocity.x = -velocity.x
      }
      if hero.position.y <= bottomLeft.y {
        hero.position.y = bottomLeft.y
        velocity.y = -velocity.y
      }
      if hero.position.y >= topRight.y {
        hero.position.y = topRight.y
        velocity.y = -velocity.y
      }
    }
    
    func moveCamera() {
      let backgroundVelocity =
        CGPoint(x: 480, y: 0)
      let amountToMove = backgroundVelocity * CGFloat(dt)
      cameraNode.position += amountToMove
      
      enumerateChildNodes(withName: "background") { node, _ in
        let background = node as! SKSpriteNode
        if background.position.x + background.size.width <
            self.cameraRect.origin.x {
          background.position = CGPoint(
            x: background.position.x + background.size.width*2,
            y: background.position.y)
        }
      }
      
    }
    
    var cameraRect : CGRect {
      let x = cameraNode.position.x - size.width/2
          + (size.width - playableRect.width)/2
      let y = cameraNode.position.y - size.height/2
          + (size.height - playableRect.height)/2
      return CGRect(
        x: x,
        y: y,
        width: playableRect.width,
        height: playableRect.height)
    }
    
    
    func checkCollisions() {

       var hitCoin: [SKSpriteNode] = []
       enumerateChildNodes(withName: "coin") { node, _ in
         let coin = node as! SKSpriteNode
         if coin.frame.intersects(self.hero.frame) {
                 hitCoin.append(coin)
                }
              }

              for coin in hitCoin {
                coinPicked(coin: coin)
              }
        
        var spikesNode: [SKSpriteNode] = []
        enumerateChildNodes(withName: "spikes") { node, _ in
          let spikes = node as! SKSpriteNode
          if spikes.frame.insetBy(dx: 40, dy: 40).intersects(self.hero.frame) {
                  spikesNode.append(spikes)
                 }
               }

               for spikes in spikesNode {
                 spikesHited(spikes: spikes)
               }
            
        
        
        var hitExit: [SKSpriteNode] = []
              enumerateChildNodes(withName: "exit") { node, _ in
                let exit = node as! SKSpriteNode
                if exit.frame.intersects(self.hero.frame) {
                    hitExit.append(self.hero)
                       }
                     }

                     for exit in hitCoin {
                        exitHitted(hero: hero)
                     }
              
    }
    
    func spikesHited(spikes: SKSpriteNode) {
              lives -= 1
             }
    
    func coinPicked(coin: SKSpriteNode) {
           coin.removeFromParent()
          exit.setScale(0.5)
           coinCollected = true
          }
    
    func exitHitted(hero: SKSpriteNode) {
               exited = true
    }
    
}


