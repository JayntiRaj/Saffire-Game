//
//  GameScene.swift
//  Saffire Game
//
//  Created by Jaynti Raj on 11/13/19.
//  Copyright © 2019 Saffire. All rights reserved.
//

import SpriteKit

let coinCategory  : UInt32 = 0x1 << 1
let groundCategory: UInt32 = 0x1 << 2
let playerCategory : UInt32 = 0x1 << 3
let forkCategory : UInt32 = 0x1 << 4

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //creating pig node
    let pig = SKSpriteNode(color: UIColor.systemPink, size: CGSize(width: 100, height: 100))
    var score = 0
    var scoreNode = SKLabelNode(text: "0")
    var lives = [SKSpriteNode(color: UIColor.systemPink, size: CGSize(width: 30, height: 30)), SKSpriteNode(color: UIColor.systemPink, size: CGSize(width: 30, height: 30)), SKSpriteNode(color: UIColor.systemPink, size: CGSize(width: 30, height: 30))]
    let gameOverNode = SKLabelNode(text: "Game Over")
    
    override func didMove(to view: SKView) {
        
       
        
        //adding touch action recognizer
        let recognizer = UITapGestureRecognizer(target: self, action: #selector((tap)))
        view.addGestureRecognizer(recognizer)
        
        //placing score display
        scoreNode.position = CGPoint(x: frame.size.width/2 - 150, y: frame.size.height/2 - 150)
        scoreNode.fontName = "GillSans-UltraBold"
        scoreNode.fontSize = 64
        scoreNode.fontColor = .orange
        addChild(scoreNode)
        
        //placing lives
        lives[0].position = CGPoint(x: -frame.size.width/2 + 100, y: frame.size.height/2 - 100)
        lives[1].position = CGPoint(x: lives[0].position.x + lives[1].size.width + 10, y: lives[0].position.y)
        lives[2].position = CGPoint(x: lives[1].position.x + lives[2].size.width + 10, y: lives[1].position.y)
        for life in lives {
            addChild(life)
        }
        
        //creating ground
        //physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -size.width / 2, y: -size.height/2), to: CGPoint(x: size.width, y: -size.height/2))
        //physicsBody?.usesPreciseCollisionDetection = true
        //physicsBody?.categoryBitMask = groundCategory
        let ground = Ground()
        addChild(ground)
        
        //setting pigs position
        pig.position = CGPoint(x: 0, y: frame.size.height/2 + pig.size.height/2)
        pig.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pig.size.width, height: pig.size.height))
        pig.physicsBody?.categoryBitMask = playerCategory
        pig.physicsBody?.contactTestBitMask = coinCategory | forkCategory
        //pig.physicsBody?.collisionBitMask = coinCategory
        //pig.physicsBody?.usesPreciseCollisionDetection = true
        addChild(pig)

        //adding gravity to the world so coins/forks/other objects fall with acceleration
        physicsWorld.gravity = CGVector(dx: 0, dy: -3.0)
        
        //set physics contact delegate
        physicsWorld.contactDelegate = self
        
        //creating falling coin nodes to run forever
        let waitCoins = SKAction.wait(forDuration: 2, withRange: 1)
        let spawnCoins = SKAction.run {
            //let coinNode = CoinFall(image: SKSpriteNode(color: UIColor.yellow, size: CGSize(width:30, height:30)))
            let coinNode = CoinFall(image: SKSpriteNode(imageNamed: "coin.png"))
            coinNode.name = "coinNode"
            self.addChild(coinNode)
            
        }
        let sequenceCoins = SKAction.sequence([waitCoins, spawnCoins])
        self.run(SKAction.repeatForever(sequenceCoins))
        
        let waitForks = SKAction.wait(forDuration: 4, withRange: 2)
        let spawnForks = SKAction.run {
            let forkNode = ForkFall(image: SKSpriteNode(color: UIColor.gray, size: CGSize(width:15, height:40)))
            forkNode.name = "forkNode"
            self.addChild(forkNode)
            
        }
        let sequenceForks = SKAction.sequence([waitForks, spawnForks])
        self.run(SKAction.repeatForever(sequenceForks))
        
    }
    
    @objc func tap(recognizer: UIGestureRecognizer) {
        let viewLocation = recognizer.location(in: view)
        let sceneLocation = convertPoint(fromView: viewLocation)
        
        if pig.hasActions() {
            pig.removeAllActions()
        }
        if sceneLocation.x>pig.position.x {
            let movePigAction = SKAction.move(to: CGPoint(x: frame.size.width/2 - pig.size.width, y:pig.position.y), duration: 2)
            pig.run(movePigAction)
        } else {
            let movePigAction = SKAction.move(to: CGPoint(x: -frame.size.width/2 + pig.size.width, y:pig.position.y), duration: 2)
            pig.run(movePigAction)
        }
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == groundCategory) && (contact.bodyB.categoryBitMask == coinCategory) {
            contact.bodyB.node?.removeFromParent()
        }
        
        if (contact.bodyA.categoryBitMask == groundCategory) && (contact.bodyB.categoryBitMask == forkCategory) {
            contact.bodyB.node?.removeFromParent()
        }
        
        if (contact.bodyA.categoryBitMask == playerCategory) && (contact.bodyB.categoryBitMask == coinCategory) {
            contact.bodyB.node?.removeFromParent()
            score = score+1
            scoreNode.text = String(score)
        }
        
        if (contact.bodyA.categoryBitMask == playerCategory) && (contact.bodyB.categoryBitMask == forkCategory) {
            contact.bodyB.node?.removeFromParent()
            let life = lives.popLast()
            life?.removeFromParent()
            if (lives.count == 0) {
                gameOver()
            }
        }
        
        
    }
    
    func gameOver() {
        self.removeAllActions()
        for child in self.children{

            if child.name == "coinNode" || child.name == "forkNode" {
                child.removeFromParent()
            }
        }
        
        gameOverNode.fontName = "GillSans-UltraBold"
        gameOverNode.fontSize = 64
        gameOverNode.fontColor = UIColor.green
        gameOverNode.position = CGPoint(x: 0, y: frame.size.height/2)
        gameOverNode.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        gameOverNode.physicsBody?.restitution = 1
        addChild(gameOverNode)
    }
    
    
    /*
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
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
     */
}
