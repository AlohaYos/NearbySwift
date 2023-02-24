//
//  AppDelegate.swift
//  NearbySwift
//
//  Created by Yos Hashimoto on 2023/02/22.
//

import UIKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, XMLParserDelegate, CLLocationManagerDelegate {

	var appData = AppData()
	var locationManager: CLLocationManager!
	var isLocationChanged: Bool = false
	var currentElement:String? = nil
	var anArticle:Article? = nil
	var parser:XMLParser!

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		locationManager = CLLocationManager()
		isLocationChanged = false
		locationManager.delegate = self
		locationManager.activityType = .fitness
		locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
		locationManager.distanceFilter = 1000.0
		locationManager.startUpdatingLocation()
		locationManager.startUpdatingHeading()

		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}

//}

//extension AppDelegate: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
		appData.heading = newHeading.trueHeading
		print("ヘディング:\(appData.heading.description)")
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		appData.coordinate = locations[0].coordinate
		_replDebugPrintln("緯度:\(appData.coordinate.latitude) 経度:\(appData.coordinate.longitude)")
		GetAndParseInformation()
//		for location in locations {
//				print("緯度:\(location.coordinate.latitude) 経度:\(location.coordinate.longitude) 取得時刻:\(location.timestamp.description)")
//		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("位置情報の取得に失敗した")
	}
	
	func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
		return true
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .notDetermined:
			locationManager.requestWhenInUseAuthorization()
			break
		case .denied:
			_replDebugPrintln("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
			// 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
			break
		case .restricted:
			_replDebugPrintln("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
			// 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
			break
		case .authorizedAlways:
			_replDebugPrintln("常時、位置情報の取得が許可されています。")
			// 位置情報取得の開始処理
			break
		case .authorizedWhenInUse:
			_replDebugPrintln("起動時のみ、位置情報の取得が許可されています。")
			// 位置情報取得の開始処理
			break
		}
	}

	// MARK: Parser
	func GetAndParseInformation() {
		let nearbyDistance = 10000
		let urlString:String = NSString(format:"https://newtonjapan.com/book/demo/NEARBY/get_nearby_xml.php?lat=%f&lon=%f&nearby=%d&count=50",
										 appData.coordinate.latitude,
										 appData.coordinate.longitude,
										 nearbyDistance
		) as String
		print(urlString)
		let url = URL(string: urlString)
		
		do {
			var content = try String(contentsOf:URL(string: urlString)!)
			print(content)
			dump(content.data(using: .utf8)!)
			parser = XMLParser(data: content.data(using: .utf8)!)
			parser.delegate = self
			print(parser.parse())
			dump(appData.articles)
		}
		catch let error {
			_replDebugPrintln("do-catch error")
		}
	}

	func parserDidStartDocument(_ parser: XMLParser) {
		_replDebugPrintln("パース開始")
	}
	
	func parserDidEndDocument(_ parser: XMLParser) {
		_replDebugPrintln("パース終了")
	}
	
	func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
		_replDebugPrintln("パースエラー発生")
		dump(parseError)
	}
	
	// 開始タグを読み込んだ時よばれる - Start
	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

		if (elementName == "article"){
			anArticle = Article()
			appData.articles.add(anArticle)
		}
		if (anArticle != nil) {
			var exist = false
			switch elementName {
			case "articleID":
				exist = true
			case "title":
				exist = true
			case "lat":
				exist = true
			case "lon":
				exist = true
			case "distance":
				exist = true
			default:
				exist = false
			}
			
			if exist {
				currentElement = ""
			}
		}
	}

	//閉じタグを読み込んだ時よばれる - End
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

		guard (currentElement != nil) else {return}
		
		switch elementName {
		case "articleID":
			anArticle?.articleID = currentElement!
		case "title":
			anArticle?.title = currentElement!
		case "lat":
			anArticle?.lat = currentElement!
		case "lon":
			anArticle?.lon = currentElement!
		case "distance":
			anArticle?.distance = currentElement!
		default:
			break
		}
		
		currentElement = nil
	}

	//タグ以外のテキストを読み込んだ時（タグとタグ間の文字列）
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		guard (currentElement != nil) else {return}
		guard (string != nil) else {return}
		currentElement?.append(string)
	}

	// MARK: Sort Function
	func DistanceSortClosestFirst(a1:Article, a2:Article) -> ComparisonResult {
		let d1 = a1.distance
		let d2 = a2.distance
		
		if d1<d2 {
			return ComparisonResult.orderedAscending
		}
		else if d1>d2 {
			return ComparisonResult.orderedDescending
		}
		else {
			return ComparisonResult.orderedSame
		}
	}

}



