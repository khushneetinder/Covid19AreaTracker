//
//  LocationService.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 11/17/20.
//

import UIKit
import CoreLocation

public let kResultKey = "LocationResultKey"
private let k10Minute = 60.0 * 10

enum Result<T> {
	case success(T)
	case failure(Error)
}

protocol LocationAccessMonitoringDelegate {
	/**
	Called every time the location access changes.
	
	- parameter access: Tells whether application has location access or not.
	 
	Whenever location access is changed from Settings>Location,
	this method will be called when application comes in foreground.
	*/
	func accessChanged(access: Bool) -> Void
}

class LocationService : NSObject {
	/**
	Location mananger solely responsible for handling location.
	*/
	let locationManager = CLLocationManager()
	
	/**
	Interval by which location is fetched. Default value is 10 minute.
	*/
	var interval: TimeInterval = k10Minute
	
	/**
	The delegate which tells whether the location access from `Settings` has been changed.
	*/
	var delegate : LocationAccessMonitoringDelegate?
	
	/**
	This date is keep to track when to throw notification about location update.
	*/
	private var startDate : Date? = nil
	/**
	Result which will hold the location and error information on success and failure respectively.
	When the result will be set then a notification `LocationDidReceived` will be thrown.
	*/
	private(set) var result : Result<CLLocation?>? {
		didSet {
			var notify = true
			switch result {
			case .success(let location): do {
				if let startDate = self.startDate {
					if (location?.timestamp.timeIntervalSince(startDate))! > interval {
						self.startDate = location?.timestamp
					}
					else {
						notify = false
					}
				}
				else {
					self.startDate = location?.timestamp
				}
			}
			default:
				break
			}
			
			if notify {
				let userInfo = [kResultKey : self.result]
				NotificationCenter.default.post(name: .LocationDidReceived, object: self, userInfo: userInfo as [AnyHashable : Any])
			}
		}
	}
	
	/**
	Tells whether the app has access for location or not. When the access given then it will request for location
	and starts the timer, otherwise stops the timer. Also notify its delegate about change in access.
	*/
	private(set) var haveAccess : Bool = false {
		didSet {
			haveAccess ? startObserving() : stopObserving()
			delegate?.accessChanged(access: haveAccess)
		}
	}
	/**
	This function immidiately request for location update.
	
	- returns: Nothing.
	- warning: User should grant the access first to retrieve the location.
	*/
	func requestLocation() -> Void {
		locationManager.requestLocation()
	}
	
	/**
	Request for location update, and starts the non stop timer which will request for location after the
	time `interval`
	
	- returns: Nothing.
	- warning: User should grant the access first to retrieve the location.
	*/
	func startObserving() {
		locationManager.startUpdatingLocation()
	}
	
	/**
	Stops monitoring the location, as this will stops the timer.
	
	- returns: Nothing.
	*/
	func stopObserving() -> Void {
		locationManager.stopUpdatingLocation()
	}
	
	/**
	Initializer
	
	On init, this will request for authorization.
	*/
	override init() {
		super.init()
		
		locationManager.requestAlwaysAuthorization()
		locationManager.requestWhenInUseAuthorization()
		
		if CLLocationManager.locationServicesEnabled() {
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
			locationManager.allowsBackgroundLocationUpdates = true
			locationManager.pausesLocationUpdatesAutomatically = false
		}
	}
}

// MARK: - Location handling
extension LocationService : CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		result = .success(manager.location)
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		result = .failure(error)
	}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		if (manager.authorizationStatus != .notDetermined) {
			haveAccess = (manager.authorizationStatus == .authorizedAlways ||
								manager.authorizationStatus == .authorizedWhenInUse)
		}
	}
}

// MARK: - Alert handling 
extension LocationService : Alertable {
	func defaultAction() {
		if let url = URL(string:UIApplication.openSettingsURLString) {
			if UIApplication.shared.canOpenURL(url) {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}
	}
	
	var alertTitle : String {
		NSLocalizedString("LocationAlertTitle", comment: "Title")
	}
	
	var defaultActionTitle : String {
		NSLocalizedString("Settings", comment: "Title")
	}
	
	var shouldShow : Bool {
		return locationManager.authorizationStatus != .authorizedWhenInUse
	}
}
