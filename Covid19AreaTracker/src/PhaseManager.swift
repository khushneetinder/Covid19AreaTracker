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
	let localNotifService = LocalNotifService()
	/**
	Initializerer
	
	Sets the phase level to notDetermined on creation.
	*/
	init() {
		phaseLevel = .notDetermined
	}
	
	/**
	Tells the current phase level.
	
	Depending on the level, the phase will be set accordingly..
	*/
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
			
			phaseChanged = oldValue != phaseLevel
		}
	}
	
	/**
	Tells whether the phase is changed or not and request for local notification.
	*/
	private (set) var phaseChanged = false {
		didSet {
			if phaseChanged {
				if let phase = self.phase {
					self.localNotifService.requestNotification(withTitle: phase.name)
				}
			}
		}
	}
	
	/**
	Current phase whose guidelines will be shown.
	*/
	var phase : IPhase?  = nil
	
	/**
	Returns the list of all possible phases.
	*/
	var phaseList : [IPhase] {
		[DarkRedPhase(), RedPhase(), YellowPhase(), GreenPhase()]
	}
}
