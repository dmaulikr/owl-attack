//
//  HelpScene.swift
//  OwlAttack2
//
//  Created by Jason La on 12/15/16.
//  Copyright © 2016 Jason La. All rights reserved.
//

import UIKit
import SpriteKit

class HelpScene: SKScene {
    let backLabel = SKLabelNode(fontNamed: "Chalkduster")
    let fontName = "Chalkduster"
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "owl-attack-background")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        self.addChild(background)
        
        backLabel.text = "Back"
        backLabel.fontSize = 25
        backLabel.fontColor = SKColor.white
        backLabel.zPosition = 1
        backLabel.horizontalAlignmentMode = .left
        backLabel.position = CGPoint(x: self.size.width * 0.01, y: self.size.height * 0.95)
        self.addChild(backLabel)
        
        let infoLabel = SKLabelNode(fontNamed: fontName)
        infoLabel.text = "Here's how to play"
        infoLabel.fontSize = 30
        infoLabel.fontColor = SKColor.white
        infoLabel.horizontalAlignmentMode = .center
        infoLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        infoLabel.zPosition = 1
        self.addChild(infoLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            if backLabel.contains(pointOfTouch) {
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.15)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}
