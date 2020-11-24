//
//  Area.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 11/17/20.
//

import Foundation

struct Area : Identifiable {
	var coordinates: String
	var id: Int
	var casePer100K : Double
	
	init(id: Int, casePer100K: Double, coordinates:String) {
		self.id = id
		self.casePer100K = casePer100K
		self.coordinates = coordinates
	}
}
