//
//  TableVC.swift
//  NearbySwift
//
//  Created by Yos Hashimoto on 2023/02/24.
//

import UIKit

class TableVC: UITableViewController {

	var appDelegate:AppDelegate?
	var appData:AppData?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
		
		self.appDelegate = UIApplication.shared.delegate as! AppDelegate
		self.appData = appDelegate?.appData
		self.title = "NearbySwift"
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return appData?.articles.count ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
		cell.nameOfPlace.text = appData?.articles[indexPath.row].title
		cell.distanceOfPlace.text = (appData?.articles[indexPath.row].distance)!+"m"
		cell.accessoryType = .disclosureIndicator
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		var selectedArticle:Article = (appData?.articles[indexPath.row])!
		print("SELECTED: \(selectedArticle.title)")
		
	}
}

