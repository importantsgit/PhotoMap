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
    let id: String = UUID().uuidString
    let title: String?
    // 제목
    let locationName: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D
    let imagefile: [UIImage]?
    
    init(
        title: String?,
        locationName: String?,
        discipline: String?,
        coordinate: CLLocationCoordinate2D,
        imagefile: [UIImage]?
    ){
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.imagefile = imagefile
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    // 부제
    
 /*   var mapItem:MKMapItem? {
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
  */
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
        //32*32 사이즈
        return UIImage(named: "cameraLocation") ?? UIImage()
    }
}



