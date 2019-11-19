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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //creating pig node
    let pig = SKSpriteNode(color: UIColor.systemPink, size: CGSize(width: 100, height: 100))
    var score = 0;
    var scoreNode = SKLabelNode(text: "0")
    
    override func didMove(to view: SKView) {
        
       
        
        //adding touch action recognizer
        let recognizer = UITapGestureRecognizer(target: self, action: #selector((tap)))
        view.addGestureRecognizer(recognizer)
        
        //placing score display
        scoreNode.position = CGPoint.zero
        addChild(scoreNode)
        
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
        pig.physicsBody?.contactTestBitMask = coinCategory
        //pig.physicsBody?.collisionBitMask = coinCategory
        //pig.physicsBody?.usesPreciseCollisionDetection = true
        addChild(pig)

        //adding gravity to the world so coins/forks/other objects fall with acceleration
        physicsWorld.gravity = CGVector(dx: 0, dy: -3.0)
        
        //set physics contact delegate
        physicsWorld.contactDelegate = self
        
        //creating falling coin nodes to run forever
        let wait = SKAction.wait(forDuration: 2, withRange: 1)
        let spawn = SKAction.run {
            let coinNode = CoinFall(image: SKSpriteNode(color: UIColor.yellow, size: CGSize(width:30, height:30)))
            self.addChild(coinNode)
            
        }
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
        
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
        
        if (contact.bodyA.categoryBitMask == playerCategory) && (contact.bodyB.categoryBitMask == coinCategory) {
            contact.bodyB.node?.removeFromParent()
            score = score+1
            print(score)
            scoreNode.text = String(score)
        }
        
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
