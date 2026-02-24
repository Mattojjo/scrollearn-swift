//
//  Fundamental.swift
//  scrollearn
//
//  Created by Leinad Suarez on 2/24/26.
//

import Foundation

struct Fundamental: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let category: String
    let difficulty: Difficulty
    let keyPoints: [String]
    
    enum Difficulty: String, Codable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
    }
    
    init(id: UUID = UUID(), title: String, description: String, category: String, difficulty: Difficulty, keyPoints: [String]) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.difficulty = difficulty
        self.keyPoints = keyPoints
    }
}
