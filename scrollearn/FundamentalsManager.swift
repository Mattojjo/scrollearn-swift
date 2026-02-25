//
//  FundamentalsManager.swift
//  scrollearn
//
//  Created by Leinad Suarez on 2/24/26.
//

import Foundation

class FundamentalsManager {
    static let shared = FundamentalsManager()
    
    private var cachedFundamentals: [Fundamental]?
    
    // MARK: - Load All Fundamentals
    
    func loadFundamentals() -> [Fundamental] {
        if let cached = cachedFundamentals {
            return cached
        }
        
        guard let url = Bundle.main.url(forResource: "fundamentals", withExtension: "json") else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let fundamentals = try JSONDecoder().decode([Fundamental].self, from: data)
            self.cachedFundamentals = fundamentals
            return fundamentals
        } catch {
            return []
        }
    }
    
    // MARK: - Filter by Difficulty
    
    func loadFundamentals(difficulty: Fundamental.Difficulty) -> [Fundamental] {
        let allFundamentals = loadFundamentals()
        return allFundamentals.filter { $0.difficulty == difficulty }
    }
    
    // MARK: - Shuffle
    
    func loadShuffledFundamentals() -> [Fundamental] {
        var fundamentals = loadFundamentals()
        fundamentals.shuffle()
        return fundamentals
    }
    
    func loadShuffledFundamentals(difficulty: Fundamental.Difficulty) -> [Fundamental] {
        var fundamentals = loadFundamentals(difficulty: difficulty)
        fundamentals.shuffle()
        return fundamentals
    }
    
    // MARK: - Async Loading
    
    func loadFundamentalsAsync() async -> [Fundamental] {
        if let cached = cachedFundamentals {
            return cached
        }
        
        guard let url = Bundle.main.url(forResource: "fundamentals", withExtension: "json") else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let fundamentals = try JSONDecoder().decode([Fundamental].self, from: data)
            await MainActor.run {
                self.cachedFundamentals = fundamentals
            }
            return fundamentals
        } catch {
            return []
        }
    }
}

