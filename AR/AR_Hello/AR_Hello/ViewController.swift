//
//  ViewController.swift
//  AR_Hello
//
//  Created by TW on 2017/11/17.
//  Copyright © 2017年 TW. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/dragon/dae.DAE")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        //添加触摸事件
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handTap(sender:)))
//        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @objc
    func handTap(sender: UITapGestureRecognizer) {
        guard let currentFrame = sceneView.session.currentFrame else {//获取当前帧
            return
        }
        
        //创建一个图片
        let imagePlane = SCNPlane(width: sceneView.bounds.width / 6000, height: sceneView.bounds.height / 6000)
        imagePlane.firstMaterial?.diffuse.contents = sceneView.snapshot()
        imagePlane.firstMaterial?.lightingModel = .constant
        
        //添加节点
        let planNode = SCNNode(geometry: imagePlane)
        sceneView.scene.rootNode.addChildNode(planNode)
        
        //设置截图的位置 10cm
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.1
        planNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    //追踪的状态发生变化
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        if case .limited(let reason) = camera.trackingState {//相机状态变成受阻状态
            
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
