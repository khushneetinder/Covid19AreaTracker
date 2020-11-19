//
//  Guidelines.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 11/11/20.
//

import Foundation

protocol IGuidelines {
	var name : String  { get }
	var title : String { get }
	var description : String { get }
}

protocol PublicGatheringGuidelines : IGuidelines { }

extension PublicGatheringGuidelines {
	var title : String {
		NSLocalizedString("PublicGatheringTitle", comment: "Title")
	}
}

protocol PrivateGatheringGuidelines : IGuidelines { }

extension PrivateGatheringGuidelines {
	var title : String {
		NSLocalizedString("PrivateGatheringTitle", comment: "Title")
	}
}

protocol MaskGuidelines : IGuidelines { }

extension MaskGuidelines {
	var title : String {
		NSLocalizedString("MaskGuidlinesTitle", comment: "Title")
	}
}

// MARK: - Concrete Guidelines -

struct PublicGatheringLow : PublicGatheringGuidelines {
	var name : String  {
		"PublicGatheringLow"
	}

	var description : String {
		NSLocalizedString("PublicGatheringLowDesc", comment: "Description")
	}
}

struct PrivateGatheringLow : PrivateGatheringGuidelines {
	var name : String  {
		"PrivateGatheringLow"
	}

	var description : String {
		NSLocalizedString("PrivateGatheringLowDesc", comment: "Description")
	}
}

struct MaskGuidlinesLow : MaskGuidelines {
	var name : String  {
		"MaskGuidlinesLow"
	}
	
	var description : String {
		NSLocalizedString("MaskGuidlinesLowDesc", comment: "Description")
	}
}

struct PublicGatheringModerate : PublicGatheringGuidelines {
	var name : String  {
		"PublicGatheringModerate"
	}
	
	var description : String {
		NSLocalizedString("PublicGatheringModerateDesc", comment: "Description")
	}
}

struct PrivateGatheringModerate : PrivateGatheringGuidelines {
	var name : String  {
		"PrivateGatheringModerate"
	}
	var title : String {
		"Private Gathering"
	}
	var description : String {
		NSLocalizedString("PrivateGatheringModerateDesc", comment: "Description")
	}
}

struct MaskGuidlinesModerate : MaskGuidelines {
	var name : String  {
		"MaskGuidlinesModerate"
	}

	var description : String {
		NSLocalizedString("MaskGuidlinesModerateDesc", comment: "Description")
	}
}

struct PublicGatheringHigh : PublicGatheringGuidelines {
	var name : String  {
		"PublicGatheringHigh"
	}

	var description : String {
		NSLocalizedString("PublicGatheringHighDesc", comment: "Description")
	}
}

struct PrivateGatheringHigh : PrivateGatheringGuidelines {
	var name : String  {
		"PrivateGatheringHigh"
	}
	
	var description : String {
		NSLocalizedString("PrivateGatheringHighDesc", comment: "Description")
	}
}

struct MaskGuidlinesHigh : MaskGuidelines {
	var name : String  {
		"MaskGuidlinesHigh"
	}

	var description : String {
		NSLocalizedString("MaskGuidlinesHighDesc", comment: "Description")
	}
}

struct PublicGatheringCritical : PublicGatheringGuidelines {
	var name : String  {
		"PublicGatheringCritical"
	}

	var description : String {
		NSLocalizedString("PublicGatheringCriticalDesc", comment: "Description")
	}
}

struct PrivateGatheringCritical : PrivateGatheringGuidelines {
	var name : String  {
		"PrivateGatheringCritical"
	}
	
	var description : String {
		NSLocalizedString("PrivateGatheringCriticalDesc", comment: "Description")
	}
}
