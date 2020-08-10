//
//  planets.swift
//  Solarist
//
//  Created by Vivek Pranavamurthi on 5/20/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import Foundation

struct orbitData: Codable{
    
    var name: String
    var x: Double
    var y: Double
    var z: Double
    var radius: Double
    
    
}

//API pull
struct planetInfo:Codable {
    var planets: [String : [mainPlanets]]
}
struct timeCoordinates:Codable {
    var timeList: [String: mainPlanets]
}

struct mainPlanets: Codable {
    
    var x: Double
    var y: Double
    var z: Double
    var radius: Double
    
}
