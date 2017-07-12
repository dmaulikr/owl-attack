//
//  OwlSlot.swift
//  OwlAttack2
//
//  Created by Jason La on 12/12/16.
//  Copyright © 2016 Jason La. All rights reserved.
//

import UIKit
import SpriteKit
import AudioToolbox

class OwlSlot: SKNode {
    var owl: SKSpriteNode!
    var owlAttack: SKSpriteNode!
    var isVisible = false
    var isHit = false
    var speedIncrease = 1.0
    var owlAssign = 0
    let owlHead = SKSpriteNode(imageNamed: "owl")
    
    func show(hideTime: Double){
        if isVisible {
            return
        }
        
        owl.xScale = 0.2
        owl.yScale = 0.2
        owl.color = .black
        //owl.colorBlendFactor = CGFloat(night * 0.3)
        
        isVisible = true
        isHit = false
        print("Speed: \(speedIncrease)")
        let variant = RandomDouble(min: 1.0, max: 1.25)
        
        let openWingsTexture = SKTexture(imageNamed: "owl-wings")
        let normalTexture = SKTexture(imageNamed: "owl")
        let babyOwlTexture = SKTexture(imageNamed: "owl-mad")
        let stop150 = SKAction.wait(forDuration: 1.5 * speedIncrease)
        let stop100 = SKAction.wait(forDuration: 1.0 * speedIncrease)
        let stop50 = SKAction.wait(forDuration: 0.50 * speedIncrease)
        let resetTexture = SKAction.setTexture(normalTexture, resize: false)
        let resetBabyOwlTexture = SKAction.setTexture(babyOwlTexture, resize: false)
        let resetSlow = SKAction.run(hideSlow)
        let rotateHead = SKAction.run(rotateOwlHead)
        let stopRotatingHead = SKAction.run(removeRotatingHead)
        let peakOut = SKAction.moveBy(x: 0, y: 30, duration: 0.5 * speedIncrease  * variant)
        let fullBody = SKAction.moveBy(x: 0, y: 50, duration: 0.05)
        let screech = SKAction.playSoundFileNamed("screech.wav", waitForCompletion: false)
        let openWings = SKAction.setTexture(openWingsTexture, resize: false)
        let attack = SKAction.run(owlAttacks)
        let reset = SKAction.run(hide)
        let shake = SKAction.run(vibrate)
        let decreaseScore = SKAction.run(decreaseLives)
        
        let dice = RandomInt(min: 0, max: 20)
        owlAssign = dice % 4
        
        if dice > 180 {
            owl.name = "extraLife"
            let showSequence = SKAction.sequence([resetTexture, peakOut, stop50, fullBody, stop50, rotateHead, stop150, resetSlow, stopRotatingHead])
            owl.run(showSequence)
            print("rotating head")
        } else if owlAssign == 0 {
            owl.name = "babyOwl"
            let babyOwlSequence = SKAction.sequence([resetBabyOwlTexture, peakOut, stop100, fullBody, stop100, resetSlow])
            owl.run(babyOwlSequence)
        } else if owlAssign == 1 {
            owl.name = "slowOwl"
            let showSequence = SKAction.sequence([resetTexture, peakOut, stop150, fullBody, stop150, openWings, stop50, screech, attack, shake, reset, decreaseScore])
            owl.run(showSequence)
        } else if owlAssign == 2 {
            owl.name = "averageOwl"
            let showSequence = SKAction.sequence([resetTexture, peakOut, stop100, fullBody, stop100, openWings, stop50, screech, attack, shake, reset, decreaseScore])
            owl.run(showSequence)
        } else if owlAssign == 3 {
            owl.name = "fastOwl"
            let showSequence = SKAction.sequence([resetTexture, peakOut, stop50, fullBody, stop50, openWings, stop50, screech, attack, shake, reset, decreaseScore])
            owl.run(showSequence)
        }
        
        speedIncrease *= 0.90
    }
    
    func rotateOwlHead() {
        owl.addChild(owlHead)
        let rotateHead = SKAction.rotate(byAngle: 45, duration: 0.5)
        rotateHead.speed = 0.03
        owlHead.run(rotateHead)
    }
    
    func removeRotatingHead() {
        owlHead.removeFromParent()
    }
    
    func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func owlAttacks() {
        print("attack called")
        owlAttack = SKSpriteNode(imageNamed: "owl-wings")
        owlAttack.position = CGPoint(x: 0, y: 0)
        owlAttack.zPosition = 2
        owlAttack.setScale(0.65)
        addChild(owlAttack)
        
        let stop25 = SKAction.wait(forDuration: 0.25)
        let owlDisappear = SKAction.removeFromParent()
        let attackSequence = SKAction.sequence([stop25, owlDisappear])
        owlAttack.run(attackSequence)
        print("attacking")
    }
    
    func hit() {
        isHit = true
        let hideOwl = SKAction.run(hide)
        owl.run(hideOwl)
    }
    
    func hide() {
        if !isVisible {
            return
        }
        
        owl.run(SKAction.moveTo(y: -90, duration: 0.05))
        isVisible = false
    }
    
    func hideSlow() {
        if !isVisible {
            return
        }
        
        owl.run(SKAction.moveTo(y: -90, duration: 0.5 * speedIncrease))
        isVisible = false
    }

    func configure(at position: CGPoint) {
        self.position = position
        
        let hole = SKSpriteNode(imageNamed: "owl-hole")
        hole.color = .black
       // hole.colorBlendFactor = CGFloat(night * 0.55)
        hole.xScale = 0.7
        hole.yScale = 0.5
        addChild(hole)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 20)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        cropNode.maskNode?.xScale = 1.5
        
        owl = SKSpriteNode(imageNamed: "owl")
        owl.position = CGPoint(x: 0, y: -90)
        owl.setScale(0.20)
        cropNode.addChild(owl)
        
        addChild(cropNode)
    }
}
