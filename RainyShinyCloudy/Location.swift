//
//  Location.swift
//  RainyShinyCloudy
//
//  Created by Árthur Ken Aramaki Mota on 29/05/17.
//  Copyright © 2017 Árthur Ken Aramaki Mota. All rights reserved.
//

import CoreLocation

class Location {
    
    static var sharedInstance = Location()
    private init() {}
    
    var latitude:Double!
    var longitude:Double!
    
}
