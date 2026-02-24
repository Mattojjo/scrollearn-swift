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
    
    /// Load fundamentals from the JSON file
    func loadFundamentals() -> [Fundamental] {
        if let cached = cachedFundamentals {
            return cached
        }
        
        guard let url = Bundle.main.url(forResource: "fundamentals", withExtension: "json") else {
            print("Failed to find fundamentals.json")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let fundamentals = try JSONDecoder().decode([Fundamental].self, from: data)
            self.cachedFundamentals = fundamentals
            return fundamentals
        } catch {
            print("Failed to decode fundamentals: \(error)")
            return []
        }
    }
    
    /// Get fundamentals filtered by category
    func getFundamentalsByCategory(_ category: String) -> [Fundamental] {
        let all = loadFundamentals()
        return all.filter { $0.category == category }
    }
    
    /// Get fundamentals filtered by difficulty
    func getFundamentalsByDifficulty(_ difficulty: Fundamental.Difficulty) -> [Fundamental] {
        let all = loadFundamentals()
        return all.filter { $0.difficulty == difficulty }
    }
    
    /// Search fundamentals by title or description
    func searchFundamentals(query: String) -> [Fundamental] {
        let all = loadFundamentals()
        let lowercaseQuery = query.lowercased()
        return all.filter { fundamental in
            fundamental.title.lowercased().contains(lowercaseQuery) ||
            fundamental.description.lowercased().contains(lowercaseQuery) ||
            fundamental.category.lowercased().contains(lowercaseQuery)
        }
    }
    
    /// Get all unique categories
    func getCategories() -> [String] {
        let all = loadFundamentals()
        let categories = Set(all.map { $0.category })
        return Array(categories).sorted()
    }
    
    /// Get fundamental by ID
    func getFundamental(byId id: UUID) -> Fundamental? {
        let all = loadFundamentals()
        return all.first { $0.id == id }
    }
}
