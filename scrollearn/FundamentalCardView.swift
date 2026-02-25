//
//  FundamentalCardView.swift
//  scrollearn
//
//  Created by Leinad Suarez on 2/24/26.
//

import SwiftUI

struct FundamentalCardView: View {
    let fundamental: Fundamental
    @State private var animationTrigger: Bool = false
    
    var body: some View {
        ZStack {
            ThemeColors.cardBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerSection
                contentSection
                Spacer()
                scrollIndicator
            }
        }
        .drawingGroup()
    }

    // MARK: - Subviews

    private var headerSection: some View {
        HStack {
            Text(fundamental.category)
                .font(.caption)
                .foregroundColor(.gray)
                .tracking(0.5)
            
            Spacer()
            
            DifficultyBadge(difficulty: fundamental.difficulty)
        }
        .padding(.horizontal, ThemeSpacing.large)
        .padding(.top, ThemeSpacing.xlarge + 12)
        .padding(.bottom, ThemeSpacing.medium)
    }

    private var contentSection: some View {
        VStack(alignment: .center, spacing: 16) {
            Text(fundamental.title)
                .font(ThemeTypography.title)
                .foregroundColor(.orange)
                .lineLimit(4)
                .multilineTextAlignment(.center)
            
            Text(fundamental.description)
                .font(ThemeTypography.subtitle)
                .foregroundColor(.gray)
                .lineLimit(5)
                .multilineTextAlignment(.center)
            
            Divider()
                .background(Color.gray.opacity(0.3))
            
            if let codeSnippet = fundamental.codeSnippet, !codeSnippet.isEmpty {
                codeExampleSection(codeSnippet)
            } else {
                keyPointsSection
            }
        }
        .padding(.horizontal, ThemeSpacing.large)
        .padding(.vertical, ThemeSpacing.medium)
    }

    private func codeExampleSection(_ codeSnippet: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Code Example")
                    .font(ThemeTypography.sectionTitle)
                    .foregroundColor(.gray)
                    .tracking(0.3)
                
                Spacer()
                
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(nil)
        }
    }

    private var keyPointsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Key Points")
                .font(ThemeTypography.sectionTitle)
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

    private var scrollIndicator: some View {
        VStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { index in
                Image(systemName: "chevron.down")
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(.gray.opacity(0.4))
                    .offset(y: animationTrigger ? 6 : 0)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.2),
                        value: animationTrigger
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 20)
        .onAppear {
            animationTrigger = true
        }
    }
}

// MARK: - Difficulty Badge

struct DifficultyBadge: View {
    let difficulty: Fundamental.Difficulty
    
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
        )
    )
}
