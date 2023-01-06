//
//  PhotoAnnotationView.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/01.
//

import MapKit

class PhotoAnnotationView: MKAnnotationView {
    // 포인트를 처음부터 이렇게 만들기
    
    lazy var mapsButton: UIButton = {
        let mapsButton = UIButton(frame: CGRect(
          origin: CGPoint.zero,
          size: CGSize(width: 48, height: 48)))
        mapsButton.layer.cornerRadius = 6
        mapsButton.clipsToBounds = true
        rightCalloutAccessoryView = mapsButton
        return mapsButton
    }()
    
    lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.numberOfLines = 0
        detailLabel.font = detailLabel.font.withSize(12)
        detailCalloutAccessoryView = detailLabel
        return detailLabel
    }()
    
    var photoInfo: Photo?
    
    override var annotation: MKAnnotation? {
        willSet {
            // 1
            //MARK: mapView( _:viewFor)와 같게
            guard let photo = newValue as? Photo else {
                return
            }
            photoInfo = photo
            canShowCallout = true
            calloutOffset = CGPoint(x: 0, y: 5)
            
            // 네비 버튼 이미지
            mapsButton.setBackgroundImage(photo.getImage()?.first, for: .normal)
            
            // 서브타이틀 라벨
            detailLabel.text = photo.subtitle
            
            //3 image
            image = photo.image
            
        }
    }
}


