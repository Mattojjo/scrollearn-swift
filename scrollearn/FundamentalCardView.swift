//
//  FundamentalCardView.swift
//  scrollearn
//
//  Created by Leinad Suarez on 2/24/26.
//

import SwiftUI

struct FundamentalCardView: View {
    let fundamental: Fundamental
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.2),
                    Color(red: 0.15, green: 0.15, blue: 0.25)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top spacer
                VStack {
                    HStack {
                        Text(fundamental.category)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .tracking(0.5)
                        
                        Spacer()
                        
                        DifficultyBadge(difficulty: fundamental.difficulty)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                }
                
                Spacer()
                
                // Main content
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    Text(fundamental.title)
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .lineLimit(3)
                    
                    // Description
                    Text(fundamental.description)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(4)
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    // Key Points
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Key Points")
                            .font(.system(size: 14, weight: .semibold, design: .default))
                            .foregroundColor(.white.opacity(0.6))
                            .tracking(0.3)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(fundamental.keyPoints, id: \.self) { point in
                                HStack(spacing: 10) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.cyan)
                                        .font(.system(size: 12))
                                    
                                    Text(point)
                                        .font(.system(size: 14, weight: .regular, design: .default))
                                        .foregroundColor(.white.opacity(0.8))
                                        .lineLimit(2)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 30)
                
                Spacer()
                
                // Bottom indicator
                VStack {
                    HStack {
                        Text("Scroll to learn more")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct DifficultyBadge: View {
    let difficulty: Fundamental.Difficulty
    
    var difficultyColor: Color {
        switch difficulty {
        case .beginner:
            return .green
        case .intermediate:
            return .orange
        case .advanced:
            return .red
        }
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .font(.system(size: 10))
            
            Text(difficulty.rawValue)
                .font(.system(size: 12, weight: .semibold, design: .default))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(difficultyColor.opacity(0.3))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(difficultyColor.opacity(0.5), lineWidth: 1)
        )
    }
}

#Preview {
    FundamentalCardView(
        fundamental: Fundamental(
            title: "Single Responsibility Principle",
            description: "A class should have only one reason to change. Each class should have a single, well-defined responsibility.",
            category: "SOLID Principles",
            difficulty: .beginner,
            keyPoints: ["One reason to change", "Focused responsibility", "Easier to test and maintain"]
        )
    )
}
