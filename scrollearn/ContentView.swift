import SwiftUI

struct ContentView: View {
    var selectedDifficulty: Fundamental.Difficulty?
    var isShuffleMode: Bool

    @State private var fundamentals: [Fundamental] = []
    @State private var selectedIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var showIndexSheet: Bool = false
    @Environment(\.scenePhase) var scenePhase

    private let dragGestureThreshold: CGFloat = 20

    init(selectedDifficulty: Fundamental.Difficulty? = nil, isShuffleMode: Bool = false) {
        self.selectedDifficulty = selectedDifficulty
        self.isShuffleMode = isShuffleMode
    }
    
    private var loadingView: some View {
        VStack(spacing: ThemeSpacing.medium) {
            ProgressView()
                .tint(.orange)
            Text("Loading fundamentals...")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ThemeColors.background.ignoresSafeArea())
    }

    private var cardsView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ForEach(Array(fundamentals.enumerated()), id: \.element.id) { index, fundamental in
                        FundamentalCardView(fundamental: fundamental)
                            .frame(height: geometry.size.height)
                            .id(index)
                    }
                }
                .offset(y: -CGFloat(selectedIndex) * geometry.size.height + dragOffset)
                .animation(.easeInOut(duration: 0.4), value: selectedIndex)
                .gesture(
                    DragGesture(minimumDistance: dragGestureThreshold)
                        .onChanged { value in
                            dragOffset = value.translation.height
                        }
                        .onEnded { value in
                            handleDragEnd(value, screenHeight: geometry.size.height)
                        }
                )
            }
            .clipped()
        }
        .zIndex(0)
    }

    var body: some View {
        ZStack {
            if fundamentals.isEmpty {
                loadingView
            } else {
                cardsView
            }
        }
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(ThemeColors.cardBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                indexCounterMenu
            }
        }
        .sheet(isPresented: $showIndexSheet) {
            IndexListView(
                totalCount: fundamentals.count,
                selectedIndex: $selectedIndex
            )
        }
        .onAppear {
            loadFundamentals()
        }
        .onChange(of: selectedIndex) { _, newValue in
            Task {
                StorageManager.shared.saveLastIndex(newValue)
            }
        }
    }

    private var indexCounterMenu: some View {
        Button {
            showIndexSheet = true
        } label: {
            Text("\(selectedIndex + 1) / \(fundamentals.count)")
                .font(ThemeTypography.indexCounter)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Helper Methods

    private func handleDragEnd(_ value: DragGesture.Value, screenHeight: CGFloat) {
        let threshold = screenHeight * 0.15

        withAnimation(.easeInOut(duration: 0.4)) {
            if value.translation.height < -threshold && selectedIndex < fundamentals.count - 1 {
                selectedIndex += 1
            } else if value.translation.height > threshold && selectedIndex > 0 {
                selectedIndex -= 1
            }

            dragOffset = 0
        }
    }

    private func loadFundamentals() {
        if isShuffleMode {
            if let difficulty = selectedDifficulty {
                fundamentals = FundamentalsManager.shared.loadShuffledFundamentals(difficulty: difficulty)
            } else {
                fundamentals = FundamentalsManager.shared.loadShuffledFundamentals()
            }
        } else if let difficulty = selectedDifficulty {
            fundamentals = FundamentalsManager.shared.loadFundamentals(difficulty: difficulty)
        } else {
            fundamentals = FundamentalsManager.shared.loadFundamentals()
        }

        if !isShuffleMode {
            let savedIndex = StorageManager.shared.loadLastIndex()
            if savedIndex < fundamentals.count {
                selectedIndex = savedIndex
            }
        }
    }
}

private struct IndexListView: View {
    let totalCount: Int
    @Binding var selectedIndex: Int
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<totalCount, id: \.self) { index in
                    Button {
                        selectedIndex = index
                        dismiss()
                    } label: {
                        HStack {
                            Text("\(index + 1)")
                            Spacer()
                            if index == selectedIndex {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Go to index")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
