//
//  DataParser.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 11/17/20.
//

import Foundation

class GeoDataParser {
	/**
	Parses the response into the `list of Area`. On completion, the `list of Area` would be provided.
	
	- parameter completion: This completion handler will be called with result.
	- returns: Nothing
	
	# Example #
	```
	dataProvider.parseData { locations in
		for item in locations {
			print(item.description)
		}
	}
	```
	*/
	func parseData(completion: @escaping ([Area]) -> (Void)) {
		var list : [Area] = []
		
		do {
			let json = try JSONSerialization.jsonObject(with: response.data(using: String.Encoding.utf8)!, options: []) as? [String:Any]
			guard let features = json?["features"] as? [[String:Any]] else {
				return
			}
			
			for item in features {
				guard let properties = item["properties"] as? [String:Any],
						let objectID = properties["OBJECTID"] as? Int,
						let cases = properties["cases_per_100k"] as? Double,
						let geometry = item["geometry"] as? [String:Any],
						let coordinates = geometry["coordinates"] as? [[[[Double]]]] else {
					break
				}
				
				let jsonEncoder = JSONEncoder()
				let jsonData = try jsonEncoder.encode(coordinates)
				
				if let coordinatesString = String(data: jsonData, encoding: String.Encoding.utf8) {
					let area = Area(id: objectID, casePer100K: cases, coordinates: coordinatesString)
					list.append(area)
				}
			}
		}
		catch let error {
			print("Caught: \(error)")
		}
		
		completion(list)
	}
	
	var response : String
	
	// MARK: Initializer 
	init(response: String) {
		self.response = response
	}
}
