//
//  GameOverScene.swift
//  OwlAttack2
//
//  Created by Jason La on 12/13/16.
//  Copyright © 2016 Jason La. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let restartLabel = SKLabelNode(fontNamed: "Chalkduster")
    let fontName = "Chalkduster"
    
    override func didMove(to view: SKView) {
        defaults.set(false, forKey: "isPaused")
        let background = SKSpriteNode(imageNamed: "owl-attack-background")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        self.addChild(background)
        
        let scoreLabel = SKLabelNode(fontNamed: fontName)
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.3)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        if score > highScoreNumber {
            highScoreNumber = score
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: fontName)
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 40
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.2)
        self.addChild(highScoreLabel)
        
        restartLabel.text = "Play again"
        restartLabel.fontSize = 70
        restartLabel.fontColor = SKColor.white
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        self.addChild(restartLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            if restartLabel.contains(pointOfTouch) {
                score = 0
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}

