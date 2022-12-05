//
//  OnBoardSlide.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/05.
//

import UIKit

struct OnBoardSlide {
    let title: String
    let animationName: String
    let buttonColor: UIColor
    let buttonTitle: String
    
    static let collection: [OnBoardSlide] = [
        .init(title: "지금 위치에서\n사진을 기억하고 싶으시다고요?", animationName: "location", buttonColor: .systemPurple, buttonTitle: "다음"),
        .init(title: "포토 앱으로 사진을 찍어보세요.\n그리고 위치와 장소를 기록해보세요.", animationName: "photo", buttonColor: .systemPurple, buttonTitle: "다음"),
        .init(title: "앱을 통해 찍은 사진은 \n찍었던 장소와 함께 기억될 것입니다.", animationName: "findlocation", buttonColor: .systemPurple, buttonTitle: "앱 사용하기")
    ]
}
