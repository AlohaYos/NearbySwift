//
//  ViewController.swift
//  NearbySwift
//
//  Created by Yos Hashimoto on 2023/02/22.
//

import UIKit
import WebKit

class WebVC: UIViewController {

	@IBOutlet weak var webView: WKWebView!
	var appDelegate:AppDelegate?
	var appData:AppData?
	var anArticle:Article?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.appDelegate = (UIApplication.shared.delegate as! AppDelegate)
		self.appData = appDelegate?.appData
		self.title = "NearbySwift"

		let safariButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: Selector(("safariButtonPushed")))
		self.navigationController?.navigationItem.rightBarButtonItem = safariButton

		let backButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: Selector(("backButtonPushed")))
		self.navigationController?.navigationItem.rightBarButtonItem = safariButton
	}

	override func viewWillAppear(_ animated: Bool) {
		var urlString = "https://newtonjapan.com/book/demo/NEARBY/wp/?p=\((anArticle?.articleID)!)"
		var url = URL(string: urlString)
		webView.load(URLRequest(url: url!))
	}

	func safariButtonPushed() {
		let url:URL! = webView.url
		UIApplication.shared.openURL(url)
	}
	
	func backButtonPushed() {
		dismiss(animated: true)
	}

}

