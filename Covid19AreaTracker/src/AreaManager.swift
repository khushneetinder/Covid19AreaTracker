//
//  AreaManager.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 11/17/20.
//

import Foundation
import CoreLocation

protocol CovidCasesMonitoringDelegate {
	/**
	Called when succefully detected number of number of Covid-19 cases for current location.
	
	- parameter cases: Number of Covid-19 cases per 100k.
	
	*/
	func succeed(withCases cases: Double) -> Void
	
	/**
	Called when failure occur while fetching or parsing data.
	
	- parameter error: Error object describing the reason of error.
	*/
	func failed(withError error: Error) -> Void
}

class AreaManager {
	let downloadService = BackdroundFetchService()
	
	/**
	The geo data api from where the data about location, cases, area, et cetera is fetched.
	*/
	var geoData : String = "https://opendata.arcgis.com/datasets/917fc37a709542548cc3be077a786c17_0.geojson"
	
	/**
	The delegate which tells about the success or failure in detecting number of cases in the region.
	*/
	var delegate : CovidCasesMonitoringDelegate?
	
	/**
	Current location of user/
	*/
	private(set) var location : CLLocation? = nil
	/**
	Fetches and parsed the geo data mentioned by the `geodata` api.
	
	- parameter currentLocationResult: Current location info if successfully retrieved the location, otherwise error.
	- returns: Nothing
	
	This function informs the delegate about the success or failure in detecting the number of cases.
	*/
	func fetchGeoData(currentLocationResult : Result<CLLocation?>?) -> Void {
		switch currentLocationResult {
		case .success(let location): do {
			self.location = location
			downloadService.startDownloading(urlString: geoData)
		}
		case .failure(let error): do {
			self.delegate?.failed(withError: error)
		}
		default:
			break
		}
	}
	
	/**
	Checks whether the reuested location is within the area or not.
	
	- parameter area: Area constructed by coordinates to look into.
	- returns: True if location is in the area, otherwise false.
	
	The detector will be used for detecting the location in the particular araa. Different detector strategy could be used.
	In this method third party GeoFeature type is used to locate location in the region.
	*/
	private func isUserWithin(area:Area) -> Bool {
		guard let location = self.location else { return false }
		
		let detector : IRegionDetector =  RegionDetectorFactory.create(withType: .geoFeatures, andCoordinates: area.coordinates)
		
		return detector.isRegionContainsLocation(location: location)
	}
	
	// MARK: - Initializer and Deintializer
	/**
	Initializerer
	
	Adds self as a observer for `LocationDidReceived` notification. Calls the selector when notification is received.
	*/
	init() {
		downloadService.delegate = self
		
		NotificationCenter.default.addObserver(self,
															selector: #selector(handleLocationDidReceived(notification:)),
															name: .LocationDidReceived, object: nil)
	}
	
	/**
	Denitializerer
	
	Removes self as a observer for `LocationDidReceived` notification.
	*/
	deinit {
		NotificationCenter.default.removeObserver(self,
																name: .LocationDidReceived,
																object: nil)
	}
	
	
	// MARK: - Notification handling 
	/**
	Fetches the geo data whenever the notification `LocationDidReceived` is received
	
	- parameter notification: Notification object with the user info specifing the location or error.
	*/
	@objc
	func handleLocationDidReceived(notification : Notification) {
		guard let dict = notification.userInfo,
				let result = dict[kResultKey] as? Result<CLLocation?>? else {
			return
		}
		
		self.fetchGeoData(currentLocationResult: result)
	}
}

extension AreaManager : DownloadedDataDelegate {
	func downloadComplete(withResult result: Result<String>) {
		switch result {
		case .success(let path): do {
			guard let url = URL(string: path) else {
				return
			}
			
			do {
				let data = try Data(contentsOf: url)
				
				if let response = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
					let parser = GeoDataParser(response: response)
					
					parser.parseData { locations in
						var locationFound = false
						for item in locations {
							if true == self.isUserWithin(area: item) {
								locationFound = true
								DispatchQueue.main.async {
									
									self.delegate?.succeed(withCases: item.casePer100K)
								}
								break
							}
						}
						
						if false == locationFound {
							let error : AreaDetectionError = .notDetermined
							self.delegate?.failed(withError: error)
						}
					}
				}
			}
			catch let error {
				self.delegate?.failed(withError: error)
			}
		}
		case .failure(let error): do {
			self.delegate?.failed(withError: error)
		}
		}
	}
}
