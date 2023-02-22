//
//  AppData.swift
//  NearbySwift
//
//  Created by Yos Hashimoto on 2023/02/22.
//

import Foundation
import CoreLocation

class AppData: NSObject {
	var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
	var heading: CLLocationDirection = 0.0
	var course: CLLocationDirection = 0.0
	var speed: CLLocationSpeed = 0.0
	var articles:NSMutableArray = []
	
	override init() {}
}
