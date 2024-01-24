//
//  Theater.swift
//  CinemaMap
//
//  Created by 은서우 on 2024/01/16.
//

import Foundation

enum CinemaType: String {
    case 롯데시네마
    case 메가박스
    case CGV
    case 전체보기
}


struct Theater {
    let type: CinemaType
    let location: String
    let latitude: Double
    let longitude: Double
}
