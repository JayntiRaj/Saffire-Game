//
//  PigGround.swift
//  Saffire Game
//
//  Created by Jaynti Raj on 12/4/19.
//  Copyright © 2019 Saffire. All rights reserved.
//

import Foundation
import SpriteKit


class PigGround: SKNode {
    
    override init() {
        super.init()
        
        //        set the size and position of the node
        //physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -size.width / 2, y: -size.height/2), to: CGPoint(x: size.width, y: -size.height/2))

        //self.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.minY + 10)
        self.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -UIScreen.main.bounds.width, y: -UIScreen.main.bounds.height/2), to: CGPoint(x: UIScreen.main.bounds.width, y: -UIScreen.main.bounds.height/2))
        self.physicsBody?.affectedByGravity = false
        
        //        apply a physics body to the node
        self.physicsBody?.isDynamic = false
        
        //        set the bitmask properties
        self.physicsBody?.categoryBitMask = groundCategory
        self.physicsBody?.contactTestBitMask = playerCategory
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
