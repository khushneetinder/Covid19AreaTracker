//
//  AlertService.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 19/11/20.
//

import Foundation
import UIKit

protocol Alertable {
	/**
	Whether to show alert or not.
	
	Depending upon this variable, `UIAlertController` is presented.
	*/
	var shouldShow : Bool { get }
	
	/**
	Returns the title of `UIAlertController`.
	*/
	var alertTitle : String { get }
	
	/**
	Returns the `title` of action of default button of UIAlertController.
	*/
	var defaultActionTitle : String { get }
	
	/**
	This function is executed when default button of UIAlertController is pressed.
	
	- returns: Nothing
	*/
	func defaultAction()
}

extension Alertable {
	/**
	Presents the UIController for a given `UIViewController`
	
	- parameter viewController: View controller where this UIAlertController will be presented.
	- parameter message: Optional message which will be shown in an alert.
	- returns: Nothing

	The alert will be shown if `shouldShow` property is true.
	*/
	func showAlertIfNeeded(forViewController viewController: UIViewController, withMessage message:String = "") {
		DispatchQueue.main.async {
			if shouldShow {
				let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
				
				alert.addAction(UIAlertAction(title: defaultActionTitle, style: .default, handler: {action in
					self.defaultAction()
				}))
				
				if cancelActionTitle != nil {
					alert.addAction(UIAlertAction(title: cancelActionTitle, style: .cancel, handler: {action in
						self.cancelAction()
					}))
				}
				
				viewController.present(alert, animated: true, completion: nil)
			}
		}
	}
	
	/**
	Returns the `nillable title` string of action of cancel button of UIAlertController.
	*/
	var cancelActionTitle : String? {
		nil
	}
	
	/**
	This function is executed when cancel button of UIAlertController is pressed.
	
	If Cancel button title is nil, then this function won't be called.
	
	- returns: Nothing
	*/
	func cancelAction() {
		
	}
}

