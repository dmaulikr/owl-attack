//
//  SKMultilineLabelNode.swift
//  OwlAttack2
//
//  Created by Jason La on 12/15/16.
//  Copyright © 2016 Jason La. All rights reserved.
//

import UIKit
import SpriteKit

class SKMultilineLabelNode: SKNode {
    var labelWidth:Int {didSet {update()}}
    var labelHeight:Int = 0
    var text:String {didSet {update()}}
    var fontName:String {didSet {update()}}
    var fontSize:CGFloat {didSet {update()}}
    var pos:CGPoint {didSet {update()}}
    var fontColor:SKColor {didSet {update()}}
    var leading:CGFloat {didSet {update()}}
    var alignment:SKLabelHorizontalAlignmentMode {didSet {update()}}
    var dontUpdate = false
    var shouldShowBorder:Bool = false {didSet {update()}}
    //display objects
    var rect:SKShapeNode?
    var labels:[SKLabelNode] = []
    
    init(text:String, labelWidth:Int, pos:CGPoint, fontName:String = "Helvetica", fontSize:CGFloat=10, fontColor:SKColor = SKColor.black, alignment:SKLabelHorizontalAlignmentMode = .left, shouldShowBorder:Bool = false)
    {
        self.text = text
        self.labelWidth = labelWidth
        self.pos = pos
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.leading = fontSize
        self.shouldShowBorder = shouldShowBorder
        self.alignment = alignment
        
        super.init()
        
        self.update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getLinesArrayOfStringInLabel(text:NSString, fontName:String, fontSize:CGFloat, width:CGFloat) -> [String] {
        
        
        let myFont:CTFont = CTFontCreateWithName(fontName as CFString?, fontSize, nil)
        let attStr:NSMutableAttributedString = NSMutableAttributedString(string: text as String)
        attStr.addAttribute(String(kCTFontAttributeName), value:myFont, range: NSMakeRange(0, attStr.length))
        let frameSetter:CTFramesetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
        let path:CGMutablePath = CGMutablePath()
        CGPathAddRect(path, nil, CGRectMake(0, 0, width, 100000))
        let frame:CTFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        let lines = CTFrameGetLines(frame) as NSArray
        var linesArray = [String]()
        
        for line in lines {
            let lineRange = CTLineGetStringRange(line as! CTLine)
            let range:NSRange = NSMakeRange(lineRange.location, lineRange.length)
            let lineString = text.substring(with: range)
            linesArray.append(lineString as String)
        }
        return linesArray
    }
    
    func update() {
        if (dontUpdate) {return}
        if (labels.count>0) {
            for label in labels {
                label.removeFromParent()
            }
            labels = []
        }
        
        
        let lines = self.getLinesArrayOfStringInLabel(text: text as NSString, fontName: self.fontName , fontSize: self.fontSize, width: CGFloat(self.labelWidth))
        var lineCount = 0
        
        for line in lines {
            
            lineCount += 1
            let label = SKLabelNode(fontNamed: fontName)
            
            label.name = "line\(lineCount)"
            label.horizontalAlignmentMode = alignment
            label.fontSize = fontSize
            label.fontColor = self.fontColor
            label.text = line
            var linePos = pos
            if (alignment == .left) {
                linePos.x -= CGFloat(labelWidth / 2)
            } else if (alignment == .right) {
                linePos.x += CGFloat(labelWidth / 2)
            }
            linePos.y += leading * CGFloat(-lineCount) * 2
            label.position =  CGPointMake( linePos.x , linePos.y )
            self.addChild(label)
            labels.append(label)
        }
        
        labelHeight = Int(CGFloat(lineCount) * leading * 2)
        showBorder()
    }
    
    
    func showBorder() {
        if (!shouldShowBorder) {return}
        if let rect = self.rect {
            self.removeChildren(in: [rect])
        }
        self.rect = SKShapeNode(rectOf: CGSize(width: labelWidth, height: labelHeight))
        if let rect = self.rect {
            rect.strokeColor = SKColor.whiteColor
            rect.lineWidth = 1
            rect.position = CGPoint(x: pos.x, y: pos.y - (CGFloat(labelHeight) / 2.0))
            self.addChild(rect)
        }
    }
}
