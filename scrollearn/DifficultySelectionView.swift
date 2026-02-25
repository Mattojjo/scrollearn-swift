//
//  DifficultySelectionView.swift
//  scrollearn
//
//  Created by Leinad Suarez on 2/25/26.
//

import SwiftUI

struct DifficultySelectionView: View {
    @Environment(\.dismiss) var dismiss
    let onDifficultySelected: (Fundamental.Difficulty?) -> Void
    let onShuffleSelected: () -> Void
    
    var body: some View {
        ZStack {
            ThemeColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                titleSection
                    .padding(.top, 80)
                    .padding(.bottom, 60)
                
                difficultyOptionsSection
                
                Spacer()
            }
        }
    }

    // MARK: - View Components

    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("Select Difficulty")
                .font(.system(size: 32, weight: .bold, design: .default))
                .foregroundColor(.white)
            
            Text("Choose your learning level")
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(.gray)
        }
    }

    private var difficultyOptionsSection: some View {
        VStack(spacing: ThemeSpacing.medium) {
            MinimalDifficultyButton(
                title: "Beginner",
                icon: "star.fill",
                accentColor: .green,
                action: {
                    onDifficultySelected(.beginner)
                    dismiss()
                }
            )
            
            MinimalDifficultyButton(
                title: "Intermediate",
                icon: "star.leadinghalf.filled",
                accentColor: .orange,
                action: {
                    onDifficultySelected(.intermediate)
                    dismiss()
                }
            )
            
            MinimalDifficultyButton(
                title: "Advanced",
                icon: "star.circle.fill",
                accentColor: .red,
                action: {
                    onDifficultySelected(.advanced)
                    dismiss()
                }
            )
            
            Divider()
                .background(Color.white.opacity(0.1))
                .padding(.vertical, 8)
            
            MinimalDifficultyButton(
                title: "Shuffle All",
                icon: "shuffle",
                accentColor: .purple,
                action: {
                    onShuffleSelected()
                    dismiss()
                }
            )
        }
        .padding(.horizontal, 48)
    }
}

// MARK: - Minimal Difficulty Button Component

struct MinimalDifficultyButton: View {
    let title: String
    let icon: String
    var accentColor: Color = .orange
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(accentColor)
                
                Text(title)
                    .font(.system(size: 18, weight: .medium, design: .default))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    DifficultySelectionView(
        onDifficultySelected: { _ in },
        onShuffleSelected: { }
    )
}
