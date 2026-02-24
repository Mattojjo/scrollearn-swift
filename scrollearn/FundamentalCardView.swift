//
//  FundamentalCardView.swift
//  scrollearn
//
//  Created by Leinad Suarez on 2/24/26.
//

import SwiftUI

let cardBackground = Color(red: 0.10, green: 0.10, blue: 0.10)

struct FundamentalCardView: View {
    let fundamental: Fundamental
    let badgeSize: CGSize

    init(fundamental: Fundamental, badgeSize: CGSize = .zero) {
        self.fundamental = fundamental
        self.badgeSize = badgeSize
    }
    
    var body: some View {
        ZStack {
            cardBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text(fundamental.category)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .tracking(0.5)
                    
                    Spacer()
                    
                    DifficultyBadge(difficulty: fundamental.difficulty, size: badgeSize)
                }
                .padding(.horizontal, 24)
                .padding(.top, 120)
                .padding(.bottom, 10)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 20) {
                    Text(fundamental.title)
                        .font(.system(size: 48, weight: .bold, design: .default))
                        .foregroundColor(.orange)
                        .lineLimit(4)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                        .frame(height: 10)
                    
                    Text(fundamental.description)
                        .font(.system(size: 22, weight: .regular, design: .default))
                        .foregroundColor(.gray)
                        .lineLimit(5)
                        .multilineTextAlignment(.center)
                    
                    Divider()
                        .background(Color.gray.opacity(0.3))
                    
                    Spacer()
                        .frame(height: 20)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Key Points")
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundColor(.gray)
                            .tracking(0.3)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(fundamental.keyPoints, id: \.self) { point in
                                HStack(spacing: 10) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.orange)
                                        .font(.system(size: 12))
                                    
                                    Text(point)
                                        .font(.system(size: 14, weight: .regular, design: .default))
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 30)
                
                VStack {
                    HStack {
                        Text("Scroll to learn more")
                            .font(.caption)
                            .foregroundColor(.gray.opacity(0.6))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray.opacity(0.6))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
                
                Spacer()
                    .frame(height: 30)
            }
        }
        .drawingGroup()
    }
}

struct DifficultyBadge: View {
    let difficulty: Fundamental.Difficulty
    let size: CGSize
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .font(.system(size: 10))
                .foregroundColor(.orange)
            
            Text(difficulty.rawValue)
                .font(.system(size: 12, weight: .semibold, design: .default))
                .foregroundColor(.orange)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .frame(
                    width: size.width > 0 ? size.width : nil,
                    height: size.height > 0 ? size.height : nil,
                    alignment: .center
                )
                .background(Color.orange.opacity(0.15))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange.opacity(0.4), lineWidth: 1)
                )
        }
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
        ),
        badgeSize: CGSize(width: 96, height: 28)
    )
}
