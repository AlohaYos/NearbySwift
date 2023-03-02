//
//  DetailVC.swift
//  NearbySwift
//
//  Created by Yos Hashimoto on 2023/02/24.
//

import UIKit
import MapKit

class DetailVC: UIViewController, MKMapViewDelegate {

	@IBOutlet weak var backButton: UIButton!
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
		naviTitle.title = anArticle?.title

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
	}

	@IBAction func backButtonPushed(_ sender: Any) {
		dismiss(animated: true)
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
		self.present(webVC, animated: true, completion: nil)
	}
}

