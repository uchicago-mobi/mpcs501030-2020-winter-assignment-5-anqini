//
//  PlaceMakerView.swift
//  assignment5
//
//  Created by Whisper on 2020/2/11.
//  Copyright © 2020 Whisper. All rights reserved.
//

import MapKit

// default place maker
class PlaceMarkerView: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
      willSet {
        clusteringIdentifier = "Place"
        displayPriority = .defaultLow
        markerTintColor = .systemRed
        glyphImage = UIImage(systemName: "pin.fill")
        }
  }
}
