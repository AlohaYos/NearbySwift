//
//  ViewController.swift
//  NearbySwift
//
//  Created by Yos Hashimoto on 2023/02/22.
//

import UIKit

class ViewController: UIViewController {

	var appDelegate:AppDelegate?
	var appData:AppData?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.appDelegate = UIApplication.shared.delegate as! AppDelegate
		self.appData = appDelegate?.appData
		self.title = "NearbySwift"
	}


}

