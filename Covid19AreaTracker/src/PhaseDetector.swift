//
//  PhaseFactory.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 11/11/20.
//

import Foundation

//MARK: - Phase level detection
protocol IPhaseLevelDetector {
	/**
	Return the phase level depending upon the strategy used.
	*/
	var level : PhaseLevel { get }
}

//MARK: - Detection strategy: Cases per 100K 

struct CaseStrategy : IPhaseLevelDetector {
	var cases : Double
	
	var level : PhaseLevel {
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
