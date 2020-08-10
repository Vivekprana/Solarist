//
//  ViewController.swift
//  Solarist
//
//  Created by Vivek Pranavamurthi on 5/20/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    //var nodeList = [SCNNode]
    
    var mainPlanets: planetInfo!
    
    var shiftX: Double = 0
    var shiftY: Double = 0
    var shiftZ: Double = 0
    
    var scale: Double = 1.0
    var earth: orbitData?
    var sun: orbitData?
    var string: String!

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        
        
        
        downloadPlanets()
    
    }

    func load() {
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
            }
        
        
        
      
        
        createObjects(planet: mainPlanets)
        
    }
    
    func createObjects(planet:planetInfo) {
        for planets in planet.planets {
            
            //Find coordinates
            let coordinates = planets.value[0]
            
            
            //Find file for planets
            let fileName = planetManager().namefinder(planetName: planets.key)
            print(fileName)
            let planetScene = SCNScene(named: fileName )
           
            //Mark the planet
            //let name = SCNBox(width: 0.03, height: 0.03, length: 0.03, chamferRadius: 0)
        
            //Find planet model
            let modelName = planetManager().modelnamefinder(planetName: planets.key)
            print(modelName)
            guard let planetNode = planetScene?.rootNode.childNode(withName: modelName, recursively: true) else {
                fatalError("sun not found")
            }
            //Find scale factor
            let scaleFactor = planetManager().scaleFinder(radius: coordinates.radius, name: planets.key)
            
            //set coordinates to planet node
            planetNode.scale = SCNVector3(scaleFactor[0], scaleFactor[1], scaleFactor[2])
            planetNode.position = SCNVector3(coordinates.x, coordinates.y, coordinates.z)
            
            sceneView.scene.rootNode.addChildNode(planetNode)
            
            // Set the node marker
            //let nodeTitle = SCNNode()
            //nodeTitle.position = SCNVector3(0, 0.05, 0)
            //nodeTitle.geometry = name
            
            
            //node.position = SCNVector3(self.scale * coordinates.x + shiftX, self.scale * coordinates.y + shiftY, self.scale * coordinates.z + shiftZ)
            
            //add the child Node
            //planetNode.addChildNode(nodeTitle)
            
            //Try Text again
            let text = SCNText(string: planets.key, extrusionDepth: 1)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.blue
            text.materials = [material]
            
            let textNode = SCNNode()
            textNode.position = SCNVector3(0, 0.05, 0)
            
            
            textNode.scale = SCNVector3(0.01/scaleFactor[0], 0.01/scaleFactor[1], 0.01/scaleFactor[2])
            textNode.geometry = text
            
            
            planetNode.addChildNode(textNode)
        
        }
    }

        
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {

        // Set touchpoint.
        //et touchPoint = sender.location(in: view)

        if sender.state == .ended {
            
            
            let location: CGPoint = sender.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
    
            // Check to see if an object was tapped.
            
                
            if !hits.isEmpty{
                let tappedNode = hits.first?.node
                
                // See if object was a label
                if tappedNode?.geometry is SCNText {
                    
                    if let planetNode  = tappedNode?.parent
                    {
                        planetCenter(node: planetNode)
                        
                        }
                    }
                        
                    // Check to see if this node has a label.
                else if tappedNode?.geometry is SCNGeometry && tappedNode?.position.x != 0 && tappedNode?.position.z != 0 && tappedNode?.position.y != 0 {
                    
                    
                    if let planetNode = tappedNode {
                        
                        planetCenter(node: planetNode)
                        }
                    }
                    
                
                       
                }


            }
        
        }
    
        
    
    func planetCenter(node: SCNNode) {
        
        // Set Variable name
        var updatedNode = node
        var centerScale:Float = 1
        
        
        //Declare anchor
        let mainAnchor = sceneView.scene.rootNode
        
        
        // This will determine the planet size.
        centerScale = 1000.0
        
        
        
        let planetPosition = node.position
        
        // Shift the tapped planet to the center (while shifting other planets.)
        for childnode in mainAnchor.childNodes {
            
            childnode.position.x -= (planetPosition.x)
            childnode.position.y -= (planetPosition.y)
            childnode.position.z -= (planetPosition.z)
        }
        
        // If planets are not to scale resize planets and distances between.
        if mainAnchor.scale.x != centerScale {
        
            for childnode in mainAnchor.childNodes {
                
                    childnode.position.x *= centerScale
                    childnode.position.y *= centerScale
                    childnode.position.z *= centerScale
                }
        
        }
        mainAnchor.scale = SCNVector3(centerScale, centerScale, centerScale)
        print(mainAnchor.scale)
        
        // Move planets around.
        
        
        
        print(mainAnchor.position)
        
        
        // Set the scale. Selected planet should be 10cm
        
         
    }
    
        
    
    func downloadPlanets() {
        
        
        print("starting block")
        guard let url = URL(string: "https://2v323npfga.execute-api.us-east-1.amazonaws.com/prod/expanse") else {
       
            fatalError("Could not access planets")
        }
        
       
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
               
                fatalError("Reading Data")
            }
            
            do {
                let planets = try JSONDecoder().decode(planetInfo.self, from: data)
                self.mainPlanets = planets
                self.load()
               
            }
            catch let error {
                print(error)
            }
        }.resume()
        
    }
    

     



}

