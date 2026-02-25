//
//  HomeView.swift
//  scrollearn
//
//  Created by Leinad Suarez on 2/25/26.
//

import SwiftUI

struct HomeView: View {
    @State private var showDifficultySelection = false
    @State private var navigateToContent = false
    @State private var selectedDifficulty: Fundamental.Difficulty?
    @State private var isShuffleMode = false
    
    private var hasActiveSession: Bool {
        StorageManager.shared.hasActiveSession()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ThemeColors.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    welcomeSection
                        .frame(maxHeight: .infinity)
                        .padding(.top, 60)
                    
                    actionButtonsSection
                        .frame(maxHeight: .infinity)
                        .padding(.bottom, 80)
                }
            }
            .navigationDestination(isPresented: $navigateToContent) {
                ContentView(
                    selectedDifficulty: selectedDifficulty,
                    isShuffleMode: isShuffleMode
                )
            }
            .sheet(isPresented: $showDifficultySelection) {
                DifficultySelectionView(
                    onDifficultySelected: handleDifficultySelected,
                    onShuffleSelected: handleShuffleSelected
                )
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - View Components

    private var welcomeSection: some View {
        VStack(spacing: ThemeSpacing.medium) {
            Image(systemName: "book.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding(.bottom, 8)
            
            Text("Scrollearn")
                .font(.system(size: 48, weight: .bold, design: .default))
                .foregroundColor(.white)
            
            Text("Master programming fundamentals\none swipe at a time")
                .font(.system(size: 18, weight: .regular, design: .default))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
    }

    private var actionButtonsSection: some View {
        VStack(spacing: ThemeSpacing.medium) {
            MinimalButton(
                title: "Start",
                icon: "play.fill",
                accentColor: .orange
            ) {
                isShuffleMode = false
                showDifficultySelection = true
            }
            
            MinimalButton(
                title: "Continue",
                icon: "arrow.right.circle.fill",
                accentColor: .orange,
                isDisabled: !hasActiveSession
            ) {
                if hasActiveSession {
                    loadActiveSession()
                    navigateToContent = true
                }
            }
        }
        .padding(.horizontal, 48)
    }

    // MARK: - Helper Methods

    private func handleDifficultySelected(_ difficulty: Fundamental.Difficulty?) {
        guard let difficulty = difficulty else { return }
        selectedDifficulty = difficulty
        isShuffleMode = false
        StorageManager.shared.saveDifficulty(difficulty.rawValue)
        StorageManager.shared.saveShuffleMode(false)
        StorageManager.shared.markSessionStarted()
        navigateToContent = true
    }

    private func handleShuffleSelected() {
        isShuffleMode = true
        selectedDifficulty = nil
        StorageManager.shared.saveShuffleMode(true)
        StorageManager.shared.clearDifficulty()
        StorageManager.shared.markSessionStarted()
        navigateToContent = true
    }

    private func loadActiveSession() {
        isShuffleMode = StorageManager.shared.isShuffleMode()
        if let savedDifficulty = StorageManager.shared.loadDifficulty() {
            selectedDifficulty = Fundamental.Difficulty(rawValue: savedDifficulty)
        }
    }
}

// MARK: - Minimal Button Component

struct MinimalButton: View {
    let title: String
    let icon: String
    var accentColor: Color = .orange
    var isDisabled: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isDisabled ? .gray.opacity(0.4) : accentColor)
                
                Text(title)
                    .font(.system(size: 18, weight: .medium, design: .default))
                    .foregroundColor(isDisabled ? .gray.opacity(0.4) : .white)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(isDisabled ? 0.03 : 0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(isDisabled ? 0.05 : 0.12), lineWidth: 1)
                    )
            )
        }
        .disabled(isDisabled)
    }
}
