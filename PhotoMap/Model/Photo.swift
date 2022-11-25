//
//  Photo.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/11/24.
//

import Foundation
import MapKit
import Contacts

class Photo: NSObject, MKAnnotation { // MKAnnotation -> 마커
    let title: String?
    // 제목
    let locationName: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D
    let imagefile: String?
    
    init(
        title: String?,
        locationName: String?,
        discipline: String?,
        coordinate: CLLocationCoordinate2D,
        imagefile: String?
    ){
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.imagefile = imagefile
        
        super.init()
    }
    
    init?(feature: MKGeoJSONFeature){ // 지형지물을 모양으로 나타냄 & Json형식 디코딩
        //1 ->
        guard
            let point = feature.geometry.first as? MKPointAnnotation,
            let propertiesData = feature.properties,
            let json = try? JSONSerialization.jsonObject(with: propertiesData), // 데이터를 Swift Dictionary으로 디코딩하는데 사용
            let properties = json as? [String: Any]
        else {
            return nil
        }
        
        //3 -> 속성 디코딩 되었으므로 사전 값에서 적절한 속정을 설정할 수 있음
        title = properties["title"] as? String
        locationName = properties["location"] as? String
        discipline = properties["discipline"] as? String
        coordinate = point.coordinate
        imagefile = properties["imagefile"] as? String
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    // 부제
    
    var mapItem:MKMapItem? {
        guard let location = locationName else {
            return nil
        }
        
        let addressDict = [CNPostalAddressStreetKey: location] // 제목
        let placemark = MKPlacemark(
            coordinate: coordinate,
            addressDictionary: addressDict
        )
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    // 네비게이션 사용을 위해 필요
    
    var markerTintColer: UIColor {
        switch discipline {
        case "Monument":
            return .red
        case "Mural":
            return .cyan
        case "Plaque":
            return .blue
        case "Sculpture" :
            return .purple
        default:
            return .green
        }
    }
    
    //MARK: 마커 안 이미지 바꾸기 / 단 실행이 안됨?
    var image: UIImage {
        guard let name = discipline else {
            return UIImage(named: "location")!
        }
        
        switch name {
            case "Monument":
            return UIImage(named: "mountain")!
            case "Mural":
                return UIImage(named: "mural")!
            case "Plaque":
                return UIImage(named: "plaque")!
            case "Sculpture" :
                return UIImage(named: "sculpture")!
            default:
                return UIImage(named: "location")!
        }
    }
    
}
