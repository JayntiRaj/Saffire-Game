//
//  CoinFall.swift
//  Saffire Game
//
//  Created by Jaynti Raj on 11/15/19.
//  Copyright © 2019 Saffire. All rights reserved.
//

import Foundation
import SpriteKit

class CoinFall: SKNode {
    
    init(image: SKSpriteNode) {
        super.init()
        
        //setting position of coin
        let randomNumber = arc4random_uniform(2)
        let x: CGFloat = randomNumber == 0 ? 1 : -1
        self.position = CGPoint(x: ((CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.width)))-image.size.width) * x), y: UIScreen.main.bounds.maxY - 112)
               
        //adding physics to coin(so it falls/rolls/bounces, etc.)
        self.physicsBody = SKPhysicsBody(circleOfRadius: image.size.width/2 )
               
        //controlling linear speed of coin
        self.physicsBody?.linearDamping = 1
               
        //add image passed as parameter to the object
        self.addChild(image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
