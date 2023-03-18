//
//  GameScene.swift
//  Jump
//
//  Created by Laurin Locher on 12.03.23.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    static let levelNames = ["Level1", "Level2", "End"]
    var level = 0
    
    let player = SKShapeNode(circleOfRadius: 16)
    let terrain = SKShapeNode(rectOf: CGSize(width: 300, height: 30 ))
    var korb: SKSpriteNode?
    let korbTexture = SKTexture(imageNamed: "Korb")

    var ränderBreite = 10
    var sceneHightmultiply: Double = 5
    
    var bottomBorder = SKShapeNode()
    var topBorder = SKShapeNode()
    var rightBorder = SKShapeNode()
    var leftBorder = SKShapeNode()

    
    var startTouch = CGPoint()
    var endTouch = CGPoint()
    
    var score = 0
    
    var camera1: SKCameraNode? = SKCameraNode()
    var followPlayer = false
    
    var background: SKNode = SKNode()
    
    class Bitmasks {
        static let playerBitmask: UInt32 = 0b1
        static let korbBitmask: UInt32 = 0b10
        static let terrainBitmask: UInt32 = 0b100
    }
    
    override func didMove(to view: SKView) {
        restartLevel()
        self.background = (self.scene!.childNode(withName: "Level")?.childNode(withName: "Background")!)!
        
        
        
        backgroundColor = .gray
        physicsWorld.contactDelegate = self
        
        scene?.addChild(camera1!)
        scene?.camera = camera1
        
        
        
    }
    func restartLevel() {
        let SceneHight = frame.height * sceneHightmultiply
        
        
        if level < GameScene.levelNames.count {
            
            loadLevel(GameScene.levelNames[level])
        }
        if level < GameScene.levelNames.count - 1 {
            
            
            let scheissKorb = self.scene!.childNode(withName: "Level")?.childNode(withName: "Korb") as? SKSpriteNode
            korb = SKSpriteNode(imageNamed: "Korb")
            korb?.position = scheissKorb!.position
            self.scene!.childNode(withName: "Level")?.addChild(korb!)
            scheissKorb?.removeFromParent()
            korb?.physicsBody = SKPhysicsBody(texture: korbTexture, size: korb!.size)
            korb?.physicsBody!.affectedByGravity = false
            korb?.physicsBody!.isDynamic = false
            korb?.physicsBody!.categoryBitMask = Bitmasks.korbBitmask
            
            setBorder(sceneHight: SceneHight)
            
            setPlayer()

            
            cameraStartMove()
            
        } else {
            camera1?.position = CGPoint(x: 0, y: 0)
            scene?.backgroundColor  = .black
            followPlayer = false
            player.removeFromParent()
            
            let feuerwerk1 = SKEmitterNode(fileNamed: "Feuerwerk1")
            
            let moveUp1 = SKAction.move(to: CGPoint(x: 10, y: 100), duration: 1)
             //let moveUp2 = SKAction.move(to: CGPoint(x: EM2.position.x, y: 500), duration: 1)
            feuerwerk1?.position = CGPoint(x: 300, y: -frame.height/2)
            addChild(feuerwerk1!)
            feuerwerk1?.run(moveUp1)
            
            let feuerwerk2 = SKEmitterNode(fileNamed: "Feuerwerk2")
            
            feuerwerk2!.position = CGPoint(x: -300 , y: -frame.height/2)
            let moveUp2 = SKAction.move(to: CGPoint(x: -10, y: 100), duration: 1)
            addChild(feuerwerk2!)
            feuerwerk2!.run(moveUp2)
            
            
        }
    }
    
    
    func cameraStartMove() {
        self.followPlayer = false
        
        let moveToKorb = SKAction.move(to: CGPoint(x: 0, y: korb!.position.y) , duration: 2.5)
        moveToKorb.timingMode = .easeInEaseOut
        
        let moveToPlayer = SKAction.move(to: CGPoint(x: 0, y: player.position.y) , duration: 2.5)
        moveToPlayer.timingMode = .easeInEaseOut

        camera1?.position = player.position
        
        camera1?.run(SKAction.sequence([moveToKorb,.wait(forDuration: 0.5), moveToPlayer]))
        
        _ = Timer.scheduledTimer(withTimeInterval: 5.5, repeats: false)  { timer in
            self.followPlayer = true
            self.player.physicsBody?.affectedByGravity = true
            self.player.physicsBody?.isDynamic = true
        }
    }
    
    func setPlayer() {
        player.strokeColor = .black
        player.fillColor = .black
        player.physicsBody = SKPhysicsBody(circleOfRadius: 16)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = false
        player.position = .init(x: 0, y: 500)
        player.physicsBody?.categoryBitMask = Bitmasks.playerBitmask
        player.physicsBody?.collisionBitMask = Bitmasks.terrainBitmask
        player.physicsBody?.contactTestBitMask = Bitmasks.korbBitmask
        player.zPosition = 10
        
        addChild(player)
        
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
    
    func loadLevel(_ name: String)
    {
        let levelScene = SKScene(fileNamed: name)
        let levelNode = SKNode()
        levelNode.name = "Level"
        
        for node in levelScene!.children {
            if node.name != "TileMap" {
                node.removeFromParent()
                levelNode.addChild(node)
            }
        }

        if let tileMap: SKTileMapNode = levelScene!.childNode(withName: "TileMap") as? SKTileMapNode {
            let tileSize = tileMap.tileSize
            let x0: CGFloat = tileMap.position.x - tileMap.mapSize.width / 2
            let y0: CGFloat = tileMap.position.y - tileMap.mapSize.height / 2
            
            for row in 0..<tileMap.numberOfRows {
                for col in 0..<tileMap.numberOfColumns {
                    if let tileDef = tileMap.tileDefinition(atColumn: col, row: row) {
                        let textureArray = tileDef.textures
                        let tileTexture = textureArray[0]
                        let x: CGFloat = x0 + CGFloat(col) * tileSize.width + tileTexture.size().width/2
                        let y: CGFloat = y0 + CGFloat(row) * tileSize.height + tileTexture.size().height/2
                        let tileNode = SKSpriteNode(texture: tileTexture, size: tileTexture.size())
                        tileNode.position = CGPoint(x: x, y: y)
                        
                        tileNode.physicsBody = SKPhysicsBody(rectangleOf: tileSize)
                        tileNode.physicsBody!.affectedByGravity = false
                        tileNode.physicsBody!.isDynamic = false
                        tileNode.physicsBody!.categoryBitMask = Bitmasks.terrainBitmask
                        
                        levelNode.addChild(tileNode)
                    }
                }
            }
        }
        self.scene!.addChild(levelNode)
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
            
            print("Kollision mit Korb")
           
            player.removeFromParent()
            
            let scaleAkct = SKAction.scale(to: 2, duration: 0.5)
            scaleAkct.timingMode = .easeInEaseOut
            
            let unscaleAkct = SKAction.scale(to: 0, duration: 0.5)
            unscaleAkct.timingMode = .easeInEaseOut
            
            
            korb!.run(SKAction.sequence([scaleAkct, unscaleAkct]))
            
            
            let _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                self.scene!.childNode(withName: "Level")!.removeFromParent()
                
                
                
                self.topBorder.removeFromParent()
                self.bottomBorder.removeFromParent()
                self.leftBorder.removeFromParent()
                self.rightBorder.removeFromParent()
                
                if self.level < GameScene.levelNames.count - 1 {
                    self.level += 1
                }
                
                self.restartLevel()
            }
            
           
        }
                    
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
        
        if player.position.y > -15 && player.position.y < frame.height * sceneHightmultiply - 0.5  - 15 && followPlayer
            
        {
            camera1?.position.y = player.position.y
            
        }
    }
}
