//
//  GameScene.swift
//  Jump
//
//  Created by Laurin Locher on 12.03.23.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
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
    var followPlayer = false
    
//    let background = SKNode(fileNamed: "Background")
    var background: SKNode = SKNode()
    
    class Bitmasks {
        static var playerBitmask: UInt32 = 0b1
        static var korbBitmask: UInt32 = 0b10
        static var terrainBitmask: UInt32 = 0b100
    }
    
    override func didMove(to view: SKView) {
    
        background = self.children [0]
        
        let SceneHight = frame.height * 3
        
        backgroundColor = .gray
        physicsWorld.contactDelegate = self
        
        scene?.addChild(camera1!)
        scene?.camera = camera1
        
        setPlayer()
        setKorb(sceneHight: SceneHight)
        createLevel()
        setBorder(sceneHight: SceneHight)
        
        cameraStartMove()
        
        
    }
    
    func cameraStartMove() {
        let moveToKorb = SKAction.move(to: korb.position, duration: 2.5)
        moveToKorb.timingMode = .easeInEaseOut
        
        let moveToPlayer = SKAction.move(to: player.position, duration: 2.5)
        moveToPlayer.timingMode = .easeInEaseOut

        
        camera1?.run(SKAction.sequence([moveToKorb,.wait(forDuration: 0.5), moveToPlayer]))
        
        _ = Timer.scheduledTimer(withTimeInterval: 5.5, repeats: false)  { timer in
            self.followPlayer = true
            self.player.physicsBody?.affectedByGravity = true
        }
    }
    
    func setPlayer() {
        player.strokeColor = .black
        player.fillColor = .black
        player.physicsBody = SKPhysicsBody(circleOfRadius: 16)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        player.position = .init(x: 0, y: 500)
        player.physicsBody?.categoryBitMask = Bitmasks.playerBitmask
        player.physicsBody?.collisionBitMask = Bitmasks.terrainBitmask
        player.physicsBody?.contactTestBitMask = Bitmasks.korbBitmask
        
        addChild(player)
        
    }
    
    func setKorb(sceneHight: CGFloat) {
        korb.position = CGPoint(x: 0, y: sceneHight - 500)
        korb.setScale(0.5)
        korb.physicsBody = SKPhysicsBody(texture: korbTexture, size: korb.size)
        korb.physicsBody?.affectedByGravity = false
        korb.physicsBody?.isDynamic = false
        korb.physicsBody?.categoryBitMask = Bitmasks.korbBitmask
        
        addChild(korb)
    }
    
    func setBorder(sceneHight: CGFloat) {
        
        bottomBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: 1))
        bottomBorder.physicsBody?.affectedByGravity = false
        bottomBorder.physicsBody?.isDynamic = false
        bottomBorder.position = .init(x: 0, y: -frame.height / 2)
        bottomBorder.physicsBody?.categoryBitMask = Bitmasks.terrainBitmask
        
        addChild(bottomBorder)
        
        topBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: 1))
        topBorder.physicsBody?.affectedByGravity = false
        topBorder.physicsBody?.isDynamic = false
        topBorder.position = .init(x: 0, y: sceneHight)
        topBorder.physicsBody?.categoryBitMask = Bitmasks.terrainBitmask
        
        addChild(topBorder)
        
        leftBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: sceneHight * 2))
        leftBorder.physicsBody?.affectedByGravity = false
        leftBorder.physicsBody?.isDynamic = false
        leftBorder.position = .init(x: ( -frame.width / 2) + 60, y: 0)
        leftBorder.physicsBody?.categoryBitMask = Bitmasks.terrainBitmask
        
        addChild(leftBorder)
        
        rightBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: sceneHight * 2))
        rightBorder.physicsBody?.affectedByGravity = false
        rightBorder.physicsBody?.isDynamic = false
        rightBorder.position = .init(x: (frame.width / 2) - 60, y: 0)
        rightBorder.physicsBody?.categoryBitMask = Bitmasks.terrainBitmask
        
        addChild(rightBorder)
    }
    func createLevel() {
        addTerrain(x: 0 , y: 0)
        
        addTerrain(x: 300, y: 600)
        addTerrain(x: -300, y: 900)
        
        addTerrain(x: 0 , y: 1200)
        
        addTerrain(x: 300, y: 1500)
        addTerrain(x: -300, y: 1800)
        
        addTerrain(x: 0 , y: 2100)
        
        addTerrain(x: 300, y: 2400)
        addTerrain(x: -300, y: 2700)
        
        addTerrain(x: 0 , y: 3000)
        
        addTerrain(x: 300, y: 3300)
        addTerrain(x: -300, y: 3300)
        
        addTerrain(x: 0 , y: 3700)
        
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
            
            let scaleAkct = SKAction.scale(to: 2, duration: 0.5)
            scaleAkct.timingMode = .easeInEaseOut
            
            let unscaleAkct = SKAction.scale(to: 0, duration: 0.5)
            unscaleAkct.timingMode = .easeInEaseOut
            
            korb.run(SKAction.sequence([scaleAkct, unscaleAkct]))
            
            
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
        if followPlayer {
            player.physicsBody?.applyImpulse(CGVector(dx: (endTouch.x - startTouch.x) * 0.5, dy: (endTouch.y - startTouch.y) * 0.5))
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        background.position.y = camera1!.position.y / -5
        
        if player.position.y > -15 && player.position.y < frame.height * 2.5  - 15 && followPlayer
        {
            camera1?.position.y = player.position.y
            
        }
    }
}
