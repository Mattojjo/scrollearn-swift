//
//  StorageManager.swift
//  scrollearn
//
//  Created by Leinad Suarez on 2/25/26.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let lastIndexKey = "lastViewedIndex"
    
    private init() {}
    
    /// Save the last viewed index
    func saveLastIndex(_ index: Int) {
        userDefaults.set(index, forKey: lastIndexKey)
    }
    
    /// Load the last viewed index, returns 0 if no saved index exists
    func loadLastIndex() -> Int {
        return userDefaults.integer(forKey: lastIndexKey)
    }
    
    /// Clear the saved index
    func clearLastIndex() {
        userDefaults.removeObject(forKey: lastIndexKey)
    }
}
