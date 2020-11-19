//
//  GuidelinesViewController.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 13/11/20.
//

import UIKit

class GuidelinesViewController: UIViewController {
	var phaseManager = PhaseManager()
	
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		collectionView.dataSource = self
		
		setupUI()
		
		fetch()
	}
	
	func setupUI() -> Void {
		tableView.dropShadow(darkMode: isDarkMode)
		tableView.cornerRadius()
		
		collectionView.dropShadow(darkMode: isDarkMode)
		collectionView.cornerRadius(radius: collectionView.frame.size.height/2)
		
		if isDarkMode {
			activityIndicator.color = .white
		}
		
		tableView.isHidden = true
		activityIndicator.startAnimating()
	}
	
	func fetch() -> Void {
		tableView.isHidden = true
		activityIndicator.startAnimating()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
			let kDummyCases : Double = 35
			let phaseDetector : IPhaseLevelDetector = CaseStrategy(cases: kDummyCases)
			
			self.phaseManager.phaseLevel = phaseDetector.get()
		
				
				self.activityIndicator.stopAnimating()
				self.activityIndicator.isHidden = true
				self.tableView.isHidden = false
				self.tableView.reloadData()
				self.collectionView.reloadData()
			
		}
	}
}

extension GuidelinesViewController : UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var numOfRows = 0
		
		if let phase = self.phaseManager.phase {
			numOfRows = phase.guidelines.count
		}
		
		return numOfRows;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: GuidelinesTableViewCell.reuseIdentifier, for: indexPath)
		
		if let phase = self.phaseManager.phase {
			let guideline = phase.guidelines[indexPath.row]
			if let cell = cell as? GuidelinesTableViewCell {
				cell.guideline = guideline
				cell.phaseColor = phase.color
			}
		}
		return cell
	}
}

extension GuidelinesViewController : UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		phaseManager.phaseList.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuidelinesIndicatorCollectionViewCell.reuseIdentifier, for: indexPath)
		
		if let cell = cell as? GuidelinesIndicatorCollectionViewCell {
			cell.phase = (indexPath.row == phaseManager.phaseLevel.rawValue) ? phaseManager.phase : nil
		}

		return cell
	}
}

