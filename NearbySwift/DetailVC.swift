//
//  DetailVC.swift
//  NearbySwift
//
//  Created by Yos Hashimoto on 2023/02/24.
//

import UIKit
import MapKit

class DetailVC: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var naviBar: UINavigationBar!
	@IBOutlet weak var naviTitle: UINavigationItem!
	
	var appDelegate:AppDelegate?
	var appData:AppData?
	var anArticle:Article?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.appDelegate = UIApplication.shared.delegate as! AppDelegate
		self.appData = appDelegate?.appData
		self.title = anArticle?.title

		tableView.delegate = self
		tableView.dataSource = self
		mapView.delegate = self
		
		// 表示リージョン
		var region:MKCoordinateRegion = mapView.region
		region.span.latitudeDelta = 0.02
		region.span.longitudeDelta = 0.02
		mapView.setRegion(region, animated: true)
		mapView.mapType = .standard

		// アノテーション
		mapView.removeAnnotations(mapView.annotations)
		let annotation = Annotation()
		annotation.coordinate.latitude = Double(anArticle!.lat)!
		annotation.coordinate.longitude = Double(anArticle!.lon)!
		annotation.title = anArticle?.title
		annotation.subtitle = "現在地から \((anArticle?.distance)!) m"
		mapView.addAnnotation(annotation)
		mapView.showAnnotations(mapView.annotations, animated: true)
		mapView.selectAnnotation(annotation, animated: true)
		
		// timer
		Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: Selector(("timerJob")), userInfo: nil, repeats: true)
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		if annotation is MKUserLocation {return nil}
		
		let reuseID = "pin"
		var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)

		if pinView==nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
		}
		else {
			pinView.annotation = annotation
		}

		pinView.rightCalloutAccessoryView = UIButton(type: .infoLight)
		pinView.canShowCallout = true
		return pinView
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebVC") as! WebVC
		webVC.anArticle = self.anArticle
		webVC.modalTransitionStyle = .flipHorizontal
		self.navigationController?.pushViewController(webVC, animated: true)
	}

	// MARK: table view
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let reuseID = "reuseCellID"
		
		var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseID)
		if cell==nil {
			cell = UITableViewCell(style:.default, reuseIdentifier: reuseID)
		}
		
		switch indexPath.row {
		case 0:
			cell?.textLabel?.text = "緯度 \((anArticle?.lat)!)"
		case 1:
			cell?.textLabel?.text = "経度 \((anArticle?.lon)!)"
		default:
			break
		}
		return cell!
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "情報"
	}
	
	// MARK: timer job
	@objc func timerJob() {
		mapView.camera.heading = appData!.heading
		mapView.setCamera(mapView.camera, animated: true)
	}
}

