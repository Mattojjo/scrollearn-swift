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
    private let selectedDifficultyKey = "selectedDifficulty"
    private let hasSessionKey = "hasSession"
    private let isShuffledKey = "isShuffled"
    
    private init() {}
    
    // MARK: - Index Management
    
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
    
    // MARK: - Difficulty Management
    
    /// Save the selected difficulty
    func saveDifficulty(_ difficulty: String) {
        userDefaults.set(difficulty, forKey: selectedDifficultyKey)
    }
    
    /// Load the selected difficulty
    func loadDifficulty() -> String? {
        return userDefaults.string(forKey: selectedDifficultyKey)
    }
    
    /// Clear the saved difficulty
    func clearDifficulty() {
        userDefaults.removeObject(forKey: selectedDifficultyKey)
    }
    
    // MARK: - Session Management
    
    /// Mark that a session has been started
    func markSessionStarted() {
        userDefaults.set(true, forKey: hasSessionKey)
    }
    
    /// Check if a session exists
    func hasActiveSession() -> Bool {
        return userDefaults.bool(forKey: hasSessionKey)
    }
    
    /// Clear the session
    func clearSession() {
        userDefaults.removeObject(forKey: hasSessionKey)
        clearLastIndex()
        clearDifficulty()
        clearShuffleMode()
    }
    
    // MARK: - Shuffle Mode Management
    
    /// Save shuffle mode state
    func saveShuffleMode(_ isShuffled: Bool) {
        userDefaults.set(isShuffled, forKey: isShuffledKey)
    }
    
    /// Load shuffle mode state
    func isShuffleMode() -> Bool {
        return userDefaults.bool(forKey: isShuffledKey)
    }
    
    /// Clear shuffle mode
    func clearShuffleMode() {
        userDefaults.removeObject(forKey: isShuffledKey)
    }
}
