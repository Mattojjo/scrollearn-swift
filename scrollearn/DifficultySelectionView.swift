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
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.12, green: 0.12, blue: 0.12),
                    Color(red: 0.08, green: 0.08, blue: 0.08)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Title
                VStack(spacing: 8) {
                    Text("Select Difficulty")
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundColor(.white)
                    
                    Text("Choose your learning level")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.gray)
                }
                .padding(.top, 80)
                .padding(.bottom, 60)
                
                // Difficulty buttons
                VStack(spacing: 16) {
                    MinimalDifficultyButton(
                        title: "Beginner",
                        icon: "star.fill",
                        accentColor: .green
                    ) {
                        onDifficultySelected(.beginner)
                        dismiss()
                    }
                    
                    MinimalDifficultyButton(
                        title: "Intermediate",
                        icon: "star.leadinghalf.filled",
                        accentColor: .orange
                    ) {
                        onDifficultySelected(.intermediate)
                        dismiss()
                    }
                    
                    MinimalDifficultyButton(
                        title: "Advanced",
                        icon: "star.circle.fill",
                        accentColor: .red
                    ) {
                        onDifficultySelected(.advanced)
                        dismiss()
                    }
                    
                    // Divider
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 1)
                        .padding(.vertical, 8)
                    
                    // Shuffle button
                    MinimalDifficultyButton(
                        title: "Shuffle All",
                        icon: "shuffle",
                        accentColor: .purple
                    ) {
                        onShuffleSelected()
                        dismiss()
                    }
                }
                .padding(.horizontal, 48)
                
                Spacer()
            }
        }
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
        onDifficultySelected: { difficulty in
            print("Selected: \(String(describing: difficulty))")
        },
        onShuffleSelected: {
            print("Shuffle selected")
        }
    )
}
