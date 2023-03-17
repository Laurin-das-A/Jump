//
//  GameScene.swift
//  Jump
//
//  Created by Laurin Locher on 12.03.23.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var cameraIsMovingFirst = false
    
    let player = SKShapeNode(circleOfRadius: 16)
    let terrain = SKShapeNode(rectOf: CGSize(width: 300, height: 30 ))
    let korb = SKSpriteNode(imageNamed: "Korb")
    let korbTexture = SKTexture(imageNamed: "Korb")
   
    var ränderBreite = 10
    
    
    var bottomBorder = SKShapeNode()
    var topBorder = SKShapeNode()
    var rightBorder = SKShapeNode()
    var leftBorder = SKShapeNode()
    
    var startTouch = CGPoint()
    var endTouch = CGPoint()
    
    var score = 0
    
    var camera1: SKCameraNode? = SKCameraNode()
    
    class Bitmasks {
        static var playerBitmask: UInt32 = 0b1
        static var korbBitmask: UInt32 = 0b10
        static var terrainBitmask: UInt32 = 0b100
    }
    
    override func didMove(to view: SKView) {
        
        cameraIsMovingFirst = true
        
        let SceneHight = frame.height * 3
        
        backgroundColor = .gray
        physicsWorld.contactDelegate = self
        
        scene?.camera = camera1
        
        
        
        player.strokeColor = .black
        player.fillColor = .black
        player.physicsBody = SKPhysicsBody(circleOfRadius: 16)
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.isDynamic = true
        player.position = .init(x: 0, y: 600)
        player.physicsBody?.categoryBitMask = Bitmasks.playerBitmask
        player.physicsBody?.collisionBitMask = Bitmasks.terrainBitmask
        player.physicsBody?.contactTestBitMask = Bitmasks.korbBitmask
        
        addChild(player)
        
        korb.position = CGPoint(x: 0, y: SceneHight - 500)
        korb.setScale(0.5)
        korb.physicsBody = SKPhysicsBody(texture: korbTexture, size: korb.size)
        korb.physicsBody?.affectedByGravity = false
        korb.physicsBody?.isDynamic = false
        korb.physicsBody?.categoryBitMask = Bitmasks.korbBitmask
        
        addChild(korb)
        
        addTerrain(x: 0 , y: 0)
        
        addTerrain(x: 300, y: 600)
        addTerrain(x: -300, y: 600)
        
        addTerrain(x: 0 , y: 900)
        
        addTerrain(x: 300, y: 1200)
        addTerrain(x: -300, y: 1200)
        
        addTerrain(x: 0 , y: 1500)
        
        addTerrain(x: 300, y: 1800)
        addTerrain(x: -300, y: 2100)
        
        addTerrain(x: 0 , y: 2400)
        
        addTerrain(x: 300, y: 2700)
        addTerrain(x: -300, y: 2700)
        
        addTerrain(x: 0 , y: 3000)
        
        addTerrain(x: 300, y: 3300)
        addTerrain(x: -300, y: 3300)
        
        
        
        bottomBorder.fillColor = .black
        
        
        bottomBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: 1))
        bottomBorder.physicsBody?.affectedByGravity = false
        bottomBorder.physicsBody?.isDynamic = false
        bottomBorder.position = .init(x: 0, y: -frame.height / 2)
        bottomBorder.physicsBody?.categoryBitMask = Bitmasks.terrainBitmask
        
        addChild(bottomBorder)
        
        topBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: 1))
        topBorder.physicsBody?.affectedByGravity = false
        topBorder.physicsBody?.isDynamic = false
        topBorder.position = .init(x: 0, y: SceneHight)
        topBorder.physicsBody?.categoryBitMask = Bitmasks.terrainBitmask
        
        addChild(topBorder)
        
        leftBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: SceneHight * 2))
        leftBorder.physicsBody?.affectedByGravity = false
        leftBorder.physicsBody?.isDynamic = false
        leftBorder.position = .init(x: ( -frame.width / 2) + 60, y: 0)
        leftBorder.physicsBody?.categoryBitMask = Bitmasks.terrainBitmask
        
        addChild(leftBorder)
        
        rightBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: SceneHight * 2))
        rightBorder.physicsBody?.affectedByGravity = false
        rightBorder.physicsBody?.isDynamic = false
        rightBorder.position = .init(x: (frame.width / 2) - 60, y: 0)
        rightBorder.physicsBody?.categoryBitMask = Bitmasks.terrainBitmask
        
        addChild(rightBorder)
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var contactA: SKPhysicsBody
        var contactB: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            contactA = contact.bodyA
            contactB = contact.bodyB

        } else {
            contactA = contact.bodyB
            contactB = contact.bodyA
        }
        
        if contactA.categoryBitMask == Bitmasks.playerBitmask && contactB.categoryBitMask == Bitmasks.korbBitmask {
            player.removeFromParent()
            print("weg")
        }
                    
    }
    
    func addTerrain(x: CGFloat, y: CGFloat) {
        let terrain = SKShapeNode(rectOf: CGSize(width: 300, height: 30 ))

        terrain.strokeColor = .brown
        terrain.fillColor = .brown
        terrain.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 300, height: 30  ))
        terrain.physicsBody?.affectedByGravity = false
        terrain.physicsBody?.isDynamic = false
        terrain.position = .init(x: x, y: y)
        terrain.physicsBody?.categoryBitMask = Bitmasks.terrainBitmask
        
        addChild(terrain)
    }
    
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            startTouch = touch.location(in: self )
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            endTouch = touch.location(in: self )
        }
        player.physicsBody?.applyImpulse(CGVector(dx: endTouch.x - startTouch.x, dy: endTouch.y - startTouch.y ))
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        
        if player.position.y > -15 && player.position.y < frame.height * 2.5  - 15{
            camera1?.position.y = player.position.y
        }
    }
}
