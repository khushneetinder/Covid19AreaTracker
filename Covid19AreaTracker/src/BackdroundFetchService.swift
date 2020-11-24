//
//  BackdroundFetchService.swift
//  BackgroundFetchSample
//
//  Created by Khushneet Inder Singh on 20/11/20.
//

import Foundation
import UIKit

protocol DownloadedDataDelegate {
	/**
	This function will be called when download is complete either with success ot failure.
	
	- parameter result: On success, path of downloaded file, otherwise error.
	- returns: Nothing.
	
	
	# Notes: #
	This will called in foreground and background as well
	*/
	func downloadComplete(withResult result:Result<String>)
}

class BackdroundFetchService: NSObject {
	/**
	Service ID of a background configuration
	*/
	let serviceID = "com.k15.casestracker.background.service.\(UUID().uuidString)"
	
	/**
	Inform the system that background task is complete
	*/
	var backgroundCompletionHandler : (() -> Void)? = nil
	
	/**
	URL Sesison which is responsible for downloading session in background.
	*/
	private lazy var urlSession: URLSession = {
		 let config = URLSessionConfiguration.background(withIdentifier: serviceID)
		 config.isDiscretionary = false
		 config.sessionSendsLaunchEvents = true
		 return URLSession(configuration: config, delegate: self, delegateQueue: nil)
	}()
	
	/**
	Delegate which is adhered by the object to keep the track of downloading
	*/
	var delegate: DownloadedDataDelegate? = nil
	
	/**
	File path of downloaded file
	*/
	var filePath : String? = nil
	
	/**
	Initiates the downloading process
	
	- parameter urlString: url to download fie from.
	
	The assumption of data to be downloaded is 30 MB
	
	- returns: Nothing
	*/
	func startDownloading(urlString : String) {
		if let url = URL(string: urlString) {
			let backgroundTask = urlSession.downloadTask(with: url)
			backgroundTask.earliestBeginDate = Date()
			backgroundTask.countOfBytesClientExpectsToSend = 1024
			backgroundTask.countOfBytesClientExpectsToReceive = 30 * 1024 * 1024
			backgroundTask.resume()
		}
	}
}

//MARK: - Data completion handling 
extension BackdroundFetchService : URLSessionDelegate {
	func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
		DispatchQueue.main.async {
			if let backgroundCompletionHandler = self.backgroundCompletionHandler {
				backgroundCompletionHandler()
			}
		}
	}
}

//MARK: - Download completion handling
extension BackdroundFetchService : URLSessionTaskDelegate {
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		if let error = error {
			filePath = nil
			delegate?.downloadComplete(withResult: .failure(error))
		} else {
			if let path = filePath {
				DispatchQueue.main.async {
					self.delegate?.downloadComplete(withResult: .success(path))
				}
			}
		}
	}
}

//MARK: - Moving downloaded file handling
extension BackdroundFetchService : URLSessionDownloadDelegate {
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		var path : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
		path.append("/Data.geojson")
		
		do {
			if FileManager.default.fileExists(atPath: path) {
				try FileManager.default.removeItem(atPath: path)
			}
			try FileManager.default.moveItem(atPath: location.path, toPath: path)

			filePath = "file://\(path)"	
		}
		catch let error {
			delegate?.downloadComplete(withResult: .failure(error))
		}
	}
}
