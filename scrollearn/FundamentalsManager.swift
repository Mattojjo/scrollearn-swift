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
    
    func loadFundamentalsAsync() async -> [Fundamental] {
        if let cached = cachedFundamentals {
            return cached
        }
        
        return await Task.detached(priority: .high) { [weak self] () -> [Fundamental] in
            guard let self = self,
                  let url = Bundle.main.url(forResource: "fundamentals", withExtension: "json") else {
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
        }.value
    }
}

