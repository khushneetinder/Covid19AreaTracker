//
//  GuidelinesIndicatorCollectionViewCell.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 13/11/20.
//

import UIKit

class GuidelinesIndicatorCollectionViewCell: UICollectionViewCell {
	static let reuseIdentifier = "GuidelinesIndicatorCell"
	
	var phase : IPhase? {
		didSet {
			if let phase = phase {
				backgroundColor = phase.color
				dropShadow(color: phase.color)
			}
			else {
				backgroundColor = .darkGray
			}
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		backgroundColor = .darkGray
		cornerRadius(radius: frame.size.height/2)
	}
}
