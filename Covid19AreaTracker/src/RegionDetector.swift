//
//  RegionDetector.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 11/11/20.
//

import Foundation
import CoreLocation
import GeoFeatures

enum RegionDetectorType {
	case geoFeatures
}

protocol IRegionDetector {
	
	/**
	Region coordinate in the form of string.
	*/
	var regionCoordinates : String { get }
	
	/**
	Detected whether the location lies  in the coordinates.
	
	- parameter location: Location under question mark.
	- returns: True if location is within the region defined by coordinates.
	*/
	func isRegionContainsLocation(location: CLLocation) -> Bool
}

struct GFRegionDetector : IRegionDetector {
	var regionCoordinates : String
	
	func isRegionContainsLocation(location: CLLocation) -> Bool {
		var isExist = false

		let currentCoordinates = "\(location.coordinate.latitude),\(location.coordinate.longitude)" /*9.410060, 54.770191*/
		let pointJsonString = "{ \"type\": \"Point\", \"coordinates\": [ \(currentCoordinates) ]}"
		let regionJsonString = "{ \"type\": \"MultiPolygon\", \"coordinates\": \(regionCoordinates) }"

		do {
			let regionJson = try JSONSerialization.jsonObject(with: regionJsonString.data(using: String.Encoding.utf8)!, options: []) as? [String:Any]

			do {
				let region = try GFGeometry.init(geoJSONGeometry: regionJson!)

				let pointJson = try JSONSerialization.jsonObject(with: pointJsonString.data(using: String.Encoding.utf8)!, options: []) as? [String:Any]

				let point = try GFGeometry.init(geoJSONGeometry: pointJson!)

				isExist = point.within(other: region)
			}
			catch let error {
				print("Caught: \(error)")
			}
		}
		catch let error {
			print("Caught: \(error)")
		}
		
		return isExist
	}
	
	/**
	Initializerer
	
	Sets the region coordinates.
	*/
	init(coordinates: String) {
		self.regionCoordinates = coordinates
	}
}

struct RegionDetectorFactory {
	/**
	Factory method to create a RegionDetector
	
	- parameter type: Type of object.
	- parameter coordinates: coordinates with which object will be created.
	- returns: Region detector object.
	
	# Notes:
	If new type of RegionDetector will be declared then add it here.
	*/
	static func create(withType type: RegionDetectorType, andCoordinates coordinates:String) -> IRegionDetector {
		switch type {
		case .geoFeatures:
			return GFRegionDetector(coordinates: coordinates)
		}
	}
}
