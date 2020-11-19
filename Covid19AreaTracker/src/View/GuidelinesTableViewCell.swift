//
//  GuidelinesTableViewCell.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 12/11/20.
//

import UIKit

class GuidelinesTableViewCell: UITableViewCell {
	static let reuseIdentifier = "GuidelinesTableCell"
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var bulletView: UIView!
	
	var guideline: IGuidelines? {
		didSet {
			if let guideline = guideline {
				titleLabel.text = guideline.title
				descriptionLabel.text = guideline.description
			}
			else {
				titleLabel.text = ""
				descriptionLabel.text = ""
			}
		}
	}
	
	var phaseColor : UIColor? {
		didSet {
			if let color = phaseColor {
				bulletView.backgroundColor = color
			}
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		
		self.cornerRadius()
		bulletView.cornerRadius(radius: bulletView.frame.size.height/2)
	}
}


