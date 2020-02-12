//
//  PlacesFavoritesDelegate.swift
//  assignment5
//
//  Created by Whisper on 2020/2/11.
//  Copyright © 2020 Whisper. All rights reserved.
//

import Foundation

protocol PlacesFavoritesDelegate {
    // set current Index
    var currentIndex: Int { get set }
    // default function not in use
    func favoritePlace(name: String) -> Void
    // recenter function for delegate to recenter the map
    func reCenter(lat: Double, long:Double, latDelta: Double, longDelta: Double) -> Void
    // update topVoew for delegate to update top view label and button image
    func updateTopView(index: Int) -> Void
}
