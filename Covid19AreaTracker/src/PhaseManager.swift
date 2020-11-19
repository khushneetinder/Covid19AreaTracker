//
//  PhaseManager.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 13/11/20.
//

import Foundation
import UIKit

enum PhaseLevel : Int{
	case critical = 0
	case high
	case moderate
	case low
	case notDetermined
}

class PhaseManager {
	var phaseLevel : PhaseLevel  {
		didSet {
			switch phaseLevel {
			case .critical:
				phase = DarkRedPhase()
			case .high:
				phase = RedPhase()
			case .moderate:
				phase = YellowPhase()
			case .low:
				phase = GreenPhase()
			case .notDetermined:
				phase = nil
			}
		}
	}
	
	var phase : IPhase?  = nil
	
	var phaseList : [IPhase] {
		[DarkRedPhase(), RedPhase(), YellowPhase(), GreenPhase()]
	}
	
	init() {
		phaseLevel = .notDetermined
	}
}
