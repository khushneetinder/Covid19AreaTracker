//
//  Utilities.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 13/11/20.
//

import Foundation
import UIKit

extension UIView {
	func dropShadow(color: UIColor = .black, scale: Bool = true, darkMode: Bool = false) {
		layer.masksToBounds = false
		layer.shadowColor = darkMode ? UIColor.white.cgColor : UIColor.black.cgColor
		layer.shadowOpacity = 1
		layer.shadowOffset = .zero
		layer.shadowRadius = 10
		layer.shouldRasterize = true
		layer.rasterizationScale = scale ? UIScreen.main.scale : 1
	}
	
	func cornerRadius(radius: CGFloat = 15) {
		layer.masksToBounds = false
		layer.cornerRadius = radius
	}
}

extension UIViewController {
	var isDarkMode: Bool {
		if #available(iOS 13.0, *) {
			return self.traitCollection.userInterfaceStyle == .dark
		}
		else {
			return false
		}
	}
}
