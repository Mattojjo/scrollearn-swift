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
                    
                    DifficultyBadge(
                        difficulty: fundamental.difficulty,
                        size: badgeSize
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 120)
                .padding(.bottom, 10)
                
                Spacer()
                    .frame(height: 20)
                
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
                        .frame(height: 0)
                    
                    // Conditionally show code snippet or key points
                    if let codeSnippet = fundamental.codeSnippet, !codeSnippet.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Code Example")
                                    .font(.system(size: 16, weight: .semibold, design: .default))
                                    .foregroundColor(.gray)
                                    .tracking(0.3)
                                
                                Spacer()
                                    .frame(height: 5)
                                
                                if let language = fundamental.language {
                                    Text(language)
                                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                                        .foregroundColor(.orange)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Color.orange.opacity(0.15))
                                        .cornerRadius(4)
                                }
                            }
                            
                            Text(codeSnippet)
                                .font(.system(size: 16, weight: .regular, design: .monospaced))
                                .foregroundColor(.orange)
                                .padding(12)
                                .background(Color.black.opacity(0.4))
                                .cornerRadius(10)
                                .frame( alignment: .leading)
                                .lineLimit(nil)
                        }
                    } else {
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
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 30)
                
                VStack {
                    // Animated scroll indicator
                    VStack(spacing: 4) {
                        ForEach(0..<3) { index in
                            Image(systemName: "chevron.down")
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(.gray.opacity(0.4))
                                .offset(y: scrollOffset(for: index))
                                .animation(
                                    Animation.easeInOut(duration: 1.5)
                                        .repeatForever(autoreverses: false)
                                        .delay(Double(index) * 0.2),
                                    value: animationTrigger
                                )
                        }
                    }
                    .padding(.bottom, 20)
                    .onAppear {
                        animationTrigger = true
                    }
                }
                
                Spacer()
                    .frame(height: 30)
            }
        }
        .drawingGroup()
    }
    
    @State private var animationTrigger: Bool = false
    
    private func scrollOffset(for index: Int) -> CGFloat {
        animationTrigger ? 6 : 0
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
            keyPoints: ["One reason to change", "Focused responsibility", "Easier to test and maintain"],
            codeSnippet: "class User {\n  func save() { }\n}\n\nclass UserRepository {\n  func save(user: User) { }\n}",
            language: "Swift"
        ),
        badgeSize: CGSize(width: 96, height: 28)
    )
}
