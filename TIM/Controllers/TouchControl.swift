//
//  TouchControl.swift
//  TIM
//
//  Created by Radharani Ribas-Valongo on 12/1/19.
//  Copyright © 2019 Radharani Ribas-Valongo. All rights reserved.
//

import SpriteKit

class TouchControl: SKSpriteNode {
    
    var alphaUnpressed: CGFloat = 0.5
    var alphaPressed: CGFloat = 0.9
    
    var pressedButton = [SKSpriteNode]()
    
    let upDirButton = SKSpriteNode(imageNamed: "updirection")
    let downDirButton = SKSpriteNode(imageNamed: "downdirection")
    let leftDirButton = SKSpriteNode(imageNamed: "leftdirection")
    let rightDirButton = SKSpriteNode(imageNamed: "rightdirection")
    
    var inputDelegate: ControlInputDelegate?
    
    init(frame: CGRect) {
        super.init(texture: nil, color: UIColor.clear, size: frame.size)
        setUpControls(size: frame.size)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //MARK: - Regular Functions
    func setUpControls(size: CGSize) {
        addButton(button: upDirButton, position: CGPoint(x: -size.width/3, y: -(size.height/4) + 50), name: "up", scale: 2.0)
        addButton(button: leftDirButton, position: CGPoint(x: -(size.width/3) - 50, y: -size.height/4), name: "left", scale: 2.0)
        addButton(button: rightDirButton, position: CGPoint(x: -(size.width/3) + 50, y: -size.height/4), name: "right", scale: 2.0)
        addButton(button: downDirButton, position: CGPoint(x: -size.width/3, y: -(size.height/4) - 50), name: "down", scale: 2.0)
        
        /*
        addButton(button: upDirButton, position: CGPoint(x: -size.width/3, y: -(size.height/4) + 50), name: "up", scale: 2.0)
        addButton(button: leftDirButton, position: CGPoint(x: -(size.width/3) - 50, y: -size.height/4), name: "left", scale: 2.0)
        addButton(button: rightDirButton, position: CGPoint(x: -(size.width/3) + 50, y: -size.height/4), name: "right", scale: 2.0)
        addButton(button: downDirButton, position: CGPoint(x: -size.width/3, y: -(size.height/4) - 50), name: "down", scale: 2.0)
 */
    }
    
    func addButton(button: SKSpriteNode, position: CGPoint, name: String, scale: CGFloat) {
        button.position = position
        button.setScale(scale)
        button.name = name
        button.zPosition = 10
        button.alpha = alphaUnpressed
        self.addChild(button)
    }
    
    //MARK: - Touches Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let directionsArray = [upDirButton, downDirButton, leftDirButton, rightDirButton]
        for i in touches{
            guard let parent = parent else {
                print("could not unwrap parentNode")
                return
            }
            let location = i.location(in: parent)
            
            for button in directionsArray {
                if button.contains(location) && pressedButton.firstIndex(of: button) == nil {
                    pressedButton.append(button)
                    handleIfInputDelegateIsNotNil(message: button.name!)
                }
                handleIfButtonIndexNilOrNot(button: button)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let directionsArray = [upDirButton, downDirButton, leftDirButton, rightDirButton]
        for i in touches {
            guard let parent = parent else {
                print("could not unwrap parentNode")
                return
            }
            let location = i.location(in: parent)
            let previousLocation = i.previousLocation(in: parent)
            
            for button in directionsArray {
                if button.contains(previousLocation) && !button.contains(location) {
                    let index = pressedButton.firstIndex(of: button)
                    if index != nil {
                        pressedButton.remove(at: index!)
                        handleIfInputDelegateIsNotNil(message: "cancel \(button.name!)")
                    }
                } else if !button.contains(previousLocation) && button.contains(location) && pressedButton.firstIndex(of: button) == nil {
                    pressedButton.append(button)
                    handleIfInputDelegateIsNotNil(message: button.name!)
                }
                handleIfButtonIndexNilOrNot(button: button)
            }
        }
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        <#code#>
//    }
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        <#code#>
//    }
//
//    func touchUp(_ touches: Set<UITouch>?, with event: UIEvent?) {
//        if let touchesUnwrapped = touches {
//
//        }
//
//        for touch in touches {
//            let location = touch.location
//        }
//    }
    
    //MARK: - Private functions
    
    private func handleIfInputDelegateIsNotNil(message: String) {
        if inputDelegate != nil {
            inputDelegate?.follow(command: message)
        }
    }
    
    private func handleIfButtonIndexNilOrNot(button: SKSpriteNode) {
        if pressedButton.firstIndex(of: button) != nil {
            button.alpha = alphaPressed
        } else {
            button.alpha = alphaUnpressed
        }
    }
}
