//
//  GuidelinesViewController.swift
//  Covid19AreaTracker
//
//  Created by Khushneet Inder Singh on 13/11/20.
//

import UIKit

class GuidelinesViewController: UIViewController {
	let phaseManager = PhaseManager()
	let locationService = LocationService()
	
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		collectionView.dataSource = self
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.areaManager.delegate = self
		locationService.delegate = self
		setupUI()
	}
	
	/**
	This function setup the state of UI elements of `view contoller`

	- returns: Nothing.
	- warning: Never call this function on background thread.
	*/
	private func setupUI() -> Void {
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
}

//MARK: - Table view handling
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

//MARK: - Collection view handling
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

//MARK: - Phase Detector
extension GuidelinesViewController : CovidCasesMonitoringDelegate {
	func succeed(withCases cases: Double) {
		
		let phaseDetector : IPhaseLevelDetector = CaseStrategy(cases: cases)
		self.phaseManager.phaseLevel = phaseDetector.level
		
		DispatchQueue.main.async {
			self.activityIndicator.stopAnimating()
			self.activityIndicator.isHidden = true
			self.tableView.isHidden = false
			self.tableView.reloadData()
			self.collectionView.reloadData()
		}
	}
	
	func failed(withError error: Error) {
		DispatchQueue.main.async {
			self.activityIndicator.stopAnimating()
			self.activityIndicator.isHidden = true
		}

		showAlertIfNeeded(forViewController: self, withMessage: error.localizedDescription)
	}
}

//MARK: - Handle Location Access
extension GuidelinesViewController : LocationAccessMonitoringDelegate {
	func accessChanged(access: Bool) {
		locationService.showAlertIfNeeded(forViewController: self)
	}
}

//MARK: - Handle Failure Alert 
extension GuidelinesViewController : Alertable {
	var shouldShow: Bool {
		true
	}
	
	var alertTitle: String {
		NSLocalizedString("GuidelinesVCAlertTitle", comment: "Title")
	}
	
	func defaultAction() {
		locationService.requestLocation()
		tableView.isHidden = true
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
	}
	
	var defaultActionTitle: String {
		NSLocalizedString("Retry", comment: "Title")
	}
}

