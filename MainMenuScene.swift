//
//  MainMenu.swift
//  OwlAttack2
//
//  Created by Jason La on 12/13/16.
//  Copyright © 2016 Jason La. All rights reserved.
//

import Foundation
import SpriteKit

let fontName = "Chalkduster"

class MainMenuScene: SKScene {
    override func didMove(to view: SKView) {
        defaults.set(false, forKey: "isPaused")
        let background = SKSpriteNode(imageNamed: "owl-attack-background")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(background)
        
        let gameName1 = SKLabelNode(fontNamed: fontName)
        gameName1.text = "Owl Attack!"
        gameName1.fontSize = 100
        gameName1.fontColor = SKColor.white
        gameName1.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        let startGame = SKLabelNode(fontNamed: fontName)
        startGame.text = "Start Game"
        startGame.fontSize = 70
        startGame.fontColor = SKColor.white
        startGame.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.45)
        startGame.zPosition = 1
        startGame.name = "startButton"
        self.addChild(startGame)
        
        let highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        let highScoreLabel = SKLabelNode(fontNamed: fontName)
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 40
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        self.addChild(highScoreLabel)
        
        let helpLabel = SKLabelNode(fontNamed: fontName)
        helpLabel.text = "How to play"
        helpLabel.fontSize = 40
        helpLabel.fontColor = SKColor.white
        helpLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.15)
        helpLabel.zPosition = 1
        helpLabel.name = "helpButton"
        self.addChild(helpLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let nodeTapped = atPoint(pointOfTouch)
            
            if nodeTapped.name == "startButton" {
                let sceneToMoveTo = GameScene(size: self.size)
                let myTransition = SKTransition.fade(withDuration: 0.15)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            } else if nodeTapped.name == "helpButton" {
                UIApplication.shared.openURL(NSURL(string: "https://jasonphuoc.github.io/") as! URL)
            }
        }
    }
}
