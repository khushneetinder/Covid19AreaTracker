//
//  LocalNotifService.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 19/11/20.
//

import Foundation
import UserNotifications

struct LocalNotifService {
	let userNotificationCenter = UserNotifications.UNUserNotificationCenter.current()
	
	/**
	This function will be responsible for requesting the authorization of notification.
	
	- returns: Nothing.

	This will request fot alert, badge and sound as well.
	
	# Notes: #
	This function needs to be called before requesting the notification.
	*/
	private func requestAuth() {
		userNotificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
			if !success {
				if let error = error {
					debugPrint(error)
				}
			}
		}
	}
	
	/**
	Request the notification centre to throw the notification.
	
	- parameter title: The notification tiltle which need to be shown in the notifiaction..
	- returns: Nothing
	
	
	# Notes: #
	The notification request will be triggered after 5 second delay
	*/
	func requestNotification(withTitle title: String) {
		let content = UNMutableNotificationContent()
		content.title = title
		content.sound = UNNotificationSound.default
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

		userNotificationCenter.add(request)
	}
	
	init() {
		requestAuth()
	}
}
