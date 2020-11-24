//
//  Phases.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 11/11/20.
//

import Foundation
import UIKit

protocol IPhase {
	var color : UIColor { get }
	var guidelines : [IGuidelines] { get }
	var name : String { get }
}

struct GreenPhase : IPhase {
	var color: UIColor {
		#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
	}
	
	var guidelines: [IGuidelines] {
		[PublicGatheringLow(), PrivateGatheringLow(), MaskGuidlinesLow()]
	}
	
	var name: String {
		NSLocalizedString("GreenPhaseName", comment: "Name")
	}
}

struct YellowPhase : IPhase {
	var color: UIColor {
		#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.1289165416, alpha: 1)
	}
	
	var guidelines: [IGuidelines] {
		[PublicGatheringModerate(), PrivateGatheringModerate(), MaskGuidlinesModerate()]
	}
	
	var name: String {
		NSLocalizedString("YellowPhaseName", comment: "Name")
	}
}

struct RedPhase : IPhase {
	var color: UIColor {
		#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
	}
	
	var guidelines: [IGuidelines] {
		[PublicGatheringHigh(), PrivateGatheringHigh(), MaskGuidlinesHigh()]
	}
	
	var name: String {
		NSLocalizedString("RedPhaseName", comment: "Name")
	}
}

struct DarkRedPhase : IPhase {
	var color: UIColor {
		#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
	}
	
	var guidelines: [IGuidelines] {
		[PublicGatheringCritical(), PrivateGatheringCritical()]
	}
	
	var name: String {
		NSLocalizedString("DarkRedPhaseName", comment: "Name")
	}
}
