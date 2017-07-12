import SpriteKit
import GameplayKit

var score = 0
var numLives = 0
var night = 0.0
let livesLabel = SKLabelNode(fontNamed: fontName)
let defaults = UserDefaults()
let gameLayer = SKNode()
let owlLayer = SKNode()
let pauseLayer = SKNode()
var timer: Timer!

func decreaseLives() {
    numLives -= 1

    if numLives < 0 {
        livesLabel.text = "Lives: 0"
    } else {
        livesLabel.text = "Lives: \(numLives)"
    }
}

class GameScene: SKScene {
    let gameOverLabel = SKLabelNode(fontNamed: fontName)
    let quitGame = SKLabelNode(fontNamed: fontName)
    let pauseButton = SKLabelNode(fontNamed: fontName)
    var popupTime = 1.0
    var slots = [OwlSlot]()
    var gameScore: SKLabelNode!
    
    var int1 = 4
    var int2 = 7
    var int3 = 10
    var int4 = 12
    
    override func didMove(to view: SKView) {
        gameLayer.removeAllChildren()
        self.addChild(gameLayer)
        gameLayer.addChild(owlLayer)
        
        numLives = 5
        
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let now = NSDate()
        let components = gregorian.components([.year, .month, .day, .hour, .minute, .second], from: now as Date)
        let hour = components.hour!
        
        let moon = SKSpriteNode(imageNamed: "owl-hole")
        moon.zPosition = -2
        
        let sun = SKSpriteNode(imageNamed: "owl-hole")
        sun.zPosition = 0
        
        let position = abs(12 - CGFloat(hour % 24))
        
        if hour > 18 || hour < 6{
            night = 1.0
            int1 = 3
            int2 = 6
            int3 = 9
            int4 = 11
            sun.zPosition = -2
            moon.zPosition = 0
        }

        moon.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.95 - position * 5)
        //gameLayer.addChild(moon)
        
        sun.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.95 - position * 20)
        //gameLayer.addChild(sun)
        
        
        let background = SKSpriteNode(imageNamed: "background")
        //background.color = .black
        //background.colorBlendFactor = CGFloat(night * 0.55)
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.blendMode = .replace
        background.zPosition = -1
        background.setScale(1)
        gameLayer.addChild(background)
        
        let pauseBackground = SKShapeNode(rectOf: CGSize(width: 875, height: 475))
        pauseBackground.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        pauseBackground.alpha = 0.5
        pauseBackground.fillColor = .black
        pauseBackground.zPosition = 99
        pauseLayer.addChild(pauseBackground)
        
        let pauseImage = SKSpriteNode(imageNamed: "owl")
        pauseImage.color = .black
        pauseImage.colorBlendFactor = CGFloat(0.5)
        pauseImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        pauseImage.zPosition = 100
        pauseLayer.addChild(pauseImage)
        
        let pauseLabel = SKLabelNode(fontNamed: fontName)
        pauseLabel.text = "Resume"
        pauseLabel.horizontalAlignmentMode = .center
        pauseLabel.fontSize = 70
        pauseLabel.fontColor = SKColor.white
        pauseLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.4)
        pauseLabel.zPosition = 101
        pauseLabel.name = "resumeButton"
        pauseLayer.addChild(pauseLabel)

        livesLabel.text = "Lives: \(numLives)"
        livesLabel.horizontalAlignmentMode = .left
        livesLabel.fontSize = 30
        livesLabel.fontColor = SKColor.white
        livesLabel.position = CGPoint(x: self.size.width * 0.01, y: self.size.height * 0.93)
        livesLabel.zPosition = 10
        gameLayer.addChild(livesLabel)
        
        pauseButton.horizontalAlignmentMode = .right
        pauseButton.text = "Pause"
        pauseButton.fontSize = 30
        pauseButton.fontColor = SKColor.white
        pauseButton.position = CGPoint(x: self.size.width * 0.99, y: self.size.height * 0.93)
        pauseButton.zPosition = 1
        pauseButton.name = "pauseButton"
        gameLayer.addChild(pauseButton)

        quitGame.horizontalAlignmentMode = .right
        quitGame.text = "Quit"
        quitGame.fontSize = 30
        quitGame.fontColor = SKColor.white
        quitGame.position = CGPoint(x: self.size.width * 0.99, y: self.size.height * 0.03)
        quitGame.zPosition = 1
        quitGame.name = "quitButton"
        gameLayer.addChild(quitGame)
        
        gameScore = SKLabelNode(fontNamed: fontName)
        gameScore.text = "Score: 0"
        gameScore.zPosition = 10
        gameScore.position = CGPoint(x: self.size.width * 0.01, y: self.size.height * 0.03)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 30
        gameLayer.addChild(gameScore)
        
        gameOverLabel.text = "Game Over!"
        gameOverLabel.zPosition = 100
        gameOverLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.6)
        gameOverLabel.fontSize = 100
        
        for i in 0 ..< 3 { createSlot(at: CGPoint(x: 270 + (i * 170), y: 280)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 220)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 150)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 90)) }
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    func pauseGame() {
        print("pausing: \(defaults.bool(forKey: "isPaused"))")
        defaults.set(true, forKey: "isPaused")
        self.isPaused = true
        
        if pauseLayer.parent == nil {
            gameLayer.addChild(pauseLayer)
        }
        
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    func unpauseGame() {
        print("unpausing: \(defaults.bool(forKey: "isPaused"))")
        defaults.set(false, forKey: "isPaused")
        self.isPaused = false
        
        if pauseLayer.parent != nil {
            pauseLayer.removeFromParent()
        }
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }
    }

    func increaseLives() {
        numLives += 1
        livesLabel.text = "Lives: \(numLives)"
    }
    
    func increaseScore() {
        score += 1
        gameScore.text = "Score: \(score)"
    }
    
    func createEnemy() {
        if numLives <= 0 && gameOverLabel.parent == nil {
            gameOver()
        }
        
        slots = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: slots) as! [OwlSlot]
        
        print("game layer is paused: \(owlLayer.isPaused)")
        print("user default \(defaults.bool(forKey: "isPaused"))")
        if defaults.bool(forKey: "isPaused") != true {
            slots[0].show(hideTime: popupTime)
            if RandomInt(min: 0, max: 12) > int1 { slots[1].show(hideTime: popupTime) }
            if RandomInt(min: 0, max: 12) > int2 { slots[2].show(hideTime: popupTime) }
            if RandomInt(min: 0, max: 12) > int3 { slots[3].show(hideTime: popupTime) }
            if RandomInt(min: 0, max: 12) > int4 { slots[4].show(hideTime: popupTime) }
            print("creating enemies")
        }
    }
    
    func moreOwls() {
        if int1 > 0 { int1 -= 1 }
        if int2 > 0 { int2 -= 1 }
        if int3 > 0 { int3 -= 1 }
        if int4 > 0 { int4 -= 1 }
        
        print("ints: \(int1) \(int2) \(int3) \(int4)")
    }
    
    func createSlot(at position: CGPoint) {
        let slot = OwlSlot()
        slot.configure(at: position)
        owlLayer.addChild(slot)
        slots.append(slot)
    }
    
    func clearGameLayer() {
        print("clearing all layers")
        
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        owlLayer.removeAllChildren()
        gameLayer.removeAllChildren()
        self.removeAllChildren()
    }
    
    func gameOver() {
        gameLayer.addChild(gameOverLabel)
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 2)
        let removeChildren = SKAction.run(clearGameLayer)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, removeChildren, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    func changeScene() {
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let tappedNodes = nodes(at: location)
            
            for node in tappedNodes {
                if node.name == "quitButton" {
                    clearGameLayer()
                    let sceneToMoveTo = MainMenuScene(size: self.size)
                    let myTransition = SKTransition.fade(withDuration: 0.15)
                    self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                } else if node.name == "pauseButton" {
                    pauseGame()
                } else if node.name == "resumeButton" {
                    unpauseGame()
                } else if node.name == "babyOwl" {
                    let owlSlot = node.parent!.parent as! OwlSlot
                    if !owlSlot.isVisible { continue }
                    if owlSlot.isHit { continue }
                    owlSlot.owl.removeAllActions()
                    owlSlot.hit()
                    moreOwls()
                } else if node.name == "slowOwl" || node.name == "averageOwl" || node.name == "fastOwl"{
                    let owlSlot = node.parent!.parent as! OwlSlot
                    if !owlSlot.isVisible { continue }
                    if owlSlot.isHit { continue }
                    owlSlot.owl.xScale = 0.15
                    owlSlot.owl.yScale = 0.15
                    owlSlot.owl.removeAllActions()
                    owlSlot.hit()
                    increaseScore()
                } else if node.name == "extraLife" {
                    increaseLives()
                }
            }
        }
    }
}
