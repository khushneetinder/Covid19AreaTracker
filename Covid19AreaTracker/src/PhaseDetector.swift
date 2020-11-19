//
//  PhaseFactory.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 11/11/20.
//

import Foundation

protocol IPhaseLevelDetector {
	func get() -> PhaseLevel
}

//MARK: - Detect phase level on the basis of cases per 100K
struct CaseStrategy : IPhaseLevelDetector {
	var cases : Double
	
	func get() -> PhaseLevel {
		switch cases {
		case 0..<35:
			return .low
		case 35...50:
			return .moderate
		case 51...100:
			return .high
		case _ where cases > 100:
			return .critical
		default:
			return .notDetermined
		}
	}
	
	init(cases : Double) {
		self.cases = cases
	}
}
