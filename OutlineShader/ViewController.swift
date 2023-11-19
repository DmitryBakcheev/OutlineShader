//
//  ViewController.swift
//  OutlineShader
//
//  Created by Dmitry Bakcheev on 11/19/23.
//

import UIKit
import ARKit



class ViewController: UIViewController, ARSCNViewDelegate {

    
    @IBOutlet var sceneView: ARSCNView!
    
    var myNode = SCNNode()
    var dublicatedNode = SCNNode()
    
    var currentAngleY: Float = 0.0
    

    
//    MARK: - viewDidLoad
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
//        setupBox()
        setupShip()
        setupShader()
        beginAutoRotation()
        gestureRecognizer()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    
    

//    MARK: - Nodes and Shader
    
    
//   It's easier to see outline effect on a simple box
//   before adding box to the scene go to OutlineShader.metal and change value of extrusion to 0.004
//   const float extrusionValue = 0.4;   ->   const float extrusionValue = 0.004;
    
    
//    func setupBox() {
//
//        myNode.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.005)
//        myNode.position = SCNVector3(0, -0.2, -0.5)
//        myNode.geometry?.materials.first?.diffuse.contents = UIColor.red
//        sceneView.scene.rootNode.addChildNode(myNode)
//    }
    
    
    func setupShip() {
        
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        myNode = scene.rootNode.childNode(withName: "shipMesh", recursively: true)!
        myNode.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
        myNode.position = SCNVector3(0, -3, -10)
        sceneView.scene = scene
    }
    
    
    func duplicateNode(_ node: SCNNode) -> SCNNode {
        
        dublicatedNode = node.copy() as? SCNNode ?? SCNNode()
        print("node copied")
        if let geometry = node.geometry?.copy() as? SCNGeometry {
            dublicatedNode.geometry = geometry
            print("geometries copied")
            if let material = geometry.firstMaterial?.copy() as? SCNMaterial {
                dublicatedNode.geometry?.firstMaterial = material
                print("materials copied")
            }
        }
        return dublicatedNode
    }
    
    
    func setupShader() {
        
        let outlineNode = duplicateNode(myNode)
        sceneView.scene.rootNode.addChildNode(outlineNode)
        
        let outlineProgram = SCNProgram()
        outlineProgram.vertexFunctionName = "outline_vertex"
        outlineProgram.fragmentFunctionName = "outline_fragment"
        
        outlineNode.geometry?.firstMaterial?.program = outlineProgram
        outlineNode.geometry?.firstMaterial?.cullMode = .front
        
    }
    
    
    
//    MARK: - Object rotation
    
    
    func gestureRecognizer() {
        let tapGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(rotateObjectManually))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func tapped(recognizer: UIGestureRecognizer) {
        
        let sceneView = recognizer.view as! SCNView
        let touchLocation = recognizer.location(in: sceneView)
        let hitResult = sceneView.hitTest(touchLocation, options: nil)
    }
    
    
    @objc func rotateObjectManually(_ gesture: UIPanGestureRecognizer) {
        
        stopAutoRotation()
        let translation = gesture.translation(in: gesture.view!)
        var newAngleY = (Float)(translation.x)*(Float)(Double.pi)/180.0
        newAngleY += currentAngleY
        myNode.eulerAngles.y = newAngleY
        dublicatedNode.eulerAngles.y = newAngleY
        
        if(gesture.state == .ended) {
            beginAutoRotation()
        }
    }
    
    
    func beginAutoRotation() {
        
        let nodeRotation = SCNAction.rotateTo(x: 0, y: 90, z: 0, duration: 60)
        let endlessRotation = SCNAction.repeatForever(nodeRotation)
        myNode.runAction(endlessRotation)
        dublicatedNode.runAction(endlessRotation)
    }
    
    
    func stopAutoRotation() {
        
        myNode.removeAllActions()
        dublicatedNode.removeAllActions()
    }
    
}
