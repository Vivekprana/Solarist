//
//  instructions.swift
//  Solarist
//
//  Created by Vivek Pranavamurthi on 5/21/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import Foundation
import UIKit



func getAllPlanetInfo() -> [orbitData] {
    var planets: [orbitData] = []
    
    let dicRoot: [String: String] = NSDictionary.init(contentsOfFile: Bundle.main.path(forResource: "planets", ofType: "plist")!) as! [String : String]
    for item in dicRoot{
        var coord = item.value

        

        let forbidden: Set<Character> = ["[","(","]", ")", ",","'"]
        coord.removeAll(where: {forbidden.contains($0)})
        var tco = coord.split(separator: " ")
       
        var name = String(item.key)
        var numberx = Double(tco[0])
        var numbery = Double(tco[1])
        var numberz = Double(tco[2])
        //adjust
        var radius = Double(tco[3])
        var adjRadius = radius!/149597870.691
        
        
        planets.append(orbitData(name: name, x: numberx!, y: numbery!, z: numberz!, radius: adjRadius))
    }
    
    
    return planets
}
class planetManager {
    
    var mainPlanets: planetInfo!

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
                self.mainPlanets? = planets
               
            }
            catch let error {
                print(error)
            }
        }.resume()
        
    }
    
    func namefinder(planetName: String) -> String {
        
    
        let filename = "planetImages/" + planetName.capitalized + ".usdz"
        return filename
  
    }
    
    func modelnamefinder(planetName: String) -> String {
       
        
        let filename = planetName.capitalized + "Model"
        return filename

        
    }
    
    func scaleFinder(radius: Double, name: String) -> [Double] {
        
        if name == "sun" {
            print(radius)
            return [0.01*radius, 0.01*radius, 0.01 * radius]
            
        }
        else {
            return [0.001 * radius, 0.001 * radius, 0.001 * radius]
        }
        
    }
    
 
    
}
