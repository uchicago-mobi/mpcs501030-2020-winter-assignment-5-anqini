//
//  DataManager.swift
//  assignment5
//
//  Created by Whisper on 2020/2/11.
//  Copyright © 2020 Whisper. All rights reserved.
//
import Foundation

// Notice: In UseDefault, we only save the index of favorite annotations
public class DataManager {

    public static let sharedInstance = DataManager()
    // load user Default
    public let defaults = UserDefaults.standard
    //This prevents others from using the default '()' initializer
    fileprivate init() {
        // remove old data
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    // load annotations
    func loadAnnotationFromPlist() -> AnnotationData {
        let path = URL(fileURLWithPath: Bundle.main.path(forResource: "Data", ofType: "plist")!)
        let data = try! Data(contentsOf: path)
        let decoder = PropertyListDecoder()
        let plistData = try! decoder.decode(AnnotationData.self, from: data)
        return plistData
    }
    
    // get favorites array and update it
    func saveFavorites(index: Int) -> Void {
        var curFavorites: Array<Int> = defaults.object(forKey: "favorites") as? [Int] ?? [Int]()
        if curFavorites.firstIndex(of: index) == nil {
            curFavorites.append(index)
        }
        defaults.set(curFavorites, forKey: "favorites")
    }
    
    // get favorites array and update it
    func deleteFavorite(index: Int) -> Void {
        var curFavorites: Array<Int> = defaults.object(forKey: "favorites") as? [Int] ?? [Int]()
        if let i = curFavorites.firstIndex(of: index) {
            curFavorites.remove(at: i)
        }
        defaults.set(curFavorites, forKey: "favorites")
    }
    
    // get favorites array and return it
    func listFavorites() -> [Int] {
        return defaults.object(forKey: "favorites") as? [Int] ?? [Int]()
    }
    
    // get faroites array and check if it is in the array
    func isFavorite(index: Int) -> Bool {
        let curFavorites: Array<Int> = defaults.object(forKey: "favorites") as? [Int] ?? [Int]()
        if curFavorites.firstIndex(of: index) != nil {
            return true
        }
        return false
    }

}
