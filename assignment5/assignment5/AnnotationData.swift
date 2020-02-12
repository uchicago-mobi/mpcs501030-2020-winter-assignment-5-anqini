//
//  AnnotationData.swift
//  assignment5
//
//  Created by Whisper on 2020/2/11.
//  Copyright © 2020 Whisper. All rights reserved.
//

import Foundation

struct  AnnotationData: Codable {
    let region: [Double]
    let places: [Annotation]
}

struct Annotation: Codable {
    let name: String
    let description: String
    let lat: Double
    let long: Double
}
