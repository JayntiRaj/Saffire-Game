//
//  MenuScene.swift
//  Saffire Game
//
//  Created by Jaynti Raj on 12/3/19.
//  Copyright © 2019 Saffire. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene : SKScene {
  let startButtonTexture = SKTexture(imageNamed: "button_start.png")
  let startButtonPressedTexture = SKTexture(imageNamed: "button_start_pressed.png")

  //let logoSprite = SKSpriteNode(imageNamed: "logo")
  var startButton : SKSpriteNode! = nil

  var selectedButton : SKSpriteNode?

  override func sceneDidLoad() {


    //Set up start button
    startButton = SKSpriteNode(texture: startButtonTexture)
    startButton.position = CGPoint.zero

    addChild(startButton)

    
  }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      if let touch = touches.first {
        if selectedButton != nil {
          handleStartButtonHover(isHovering: false)
        }

        // Check which button was clicked (if any)
        if startButton.contains(touch.location(in: self)) {
          selectedButton = startButton
          handleStartButtonHover(isHovering: true)
        }
      }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      if let touch = touches.first {

        // Check which button was clicked (if any)
        if selectedButton == startButton {
          handleStartButtonHover(isHovering: (startButton.contains(touch.location(in: self))))
        }
      }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      if let touch = touches.first {

        if selectedButton == startButton {
          // Start button clicked
          handleStartButtonHover(isHovering: false)

          if (startButton.contains(touch.location(in: self))) {
            handleStartButtonClick()
          }

        } 
      }

      selectedButton = nil
    }

    /// Handles start button hover behavior
    func handleStartButtonHover(isHovering : Bool) {
      if isHovering {
        startButton.texture = startButtonPressedTexture
      } else {
        startButton.texture = startButtonTexture
      }
    }

    /// Stubbed out start button on click method
    func handleStartButtonClick() {
        let transition = SKTransition.reveal(with: .down, duration: 1.5)
      let gameScene = SKScene(fileNamed: "GameScene")
        gameScene?.scaleMode = .aspectFill
      //gameScene.scaleMode = scaleMode
        view?.presentScene(gameScene!, transition: transition)
    }

}
