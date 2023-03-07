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
		self.title = "詳細情報"

		let safariButton = UIBarButtonItem(title: "Safari", style: .plain, target: self, action: Selector(("safariButtonPushed")))
//		UIBarButtonItem(barButtonSystemItem: .save, target: self, action: Selector(("safariButtonPushed")))
		self.navigationItem.rightBarButtonItem = safariButton
		
		
	}

	override func viewWillAppear(_ animated: Bool) {
		var urlString = "https://newtonjapan.com/book/demo/NEARBY/wp/?p=\((anArticle?.articleID)!)"
		var url = URL(string: urlString)
		webView.load(URLRequest(url: url!))
	}

	@objc func safariButtonPushed() {
		let url:URL! = webView.url
		UIApplication.shared.openURL(url)
	}
}

