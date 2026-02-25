import SwiftUI

struct ContentView: View {
    var selectedDifficulty: Fundamental.Difficulty?
    var isShuffleMode: Bool

    @State private var fundamentals: [Fundamental] = []
    @State private var selectedIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var indexBadgeSize: CGSize = .zero
    @State private var showIndexMenu: Bool = false
    @State private var counterButtonWidth: CGFloat = 0
    @Environment(\.scenePhase) var scenePhase

    private let maxVisibleItems = 15

    init(selectedDifficulty: Fundamental.Difficulty? = nil, isShuffleMode: Bool = false) {
        self.selectedDifficulty = selectedDifficulty
        self.isShuffleMode = isShuffleMode
    }

    var body: some View {
        ZStack {
            if fundamentals.isEmpty {
                VStack(spacing: 16) {
                    ProgressView()
                        .tint(.orange)
                    Text("Loading fundamentals...")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.12, green: 0.12, blue: 0.12),
                            Color(red: 0.08, green: 0.08, blue: 0.08)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                )
            } else {
                GeometryReader { geometry in
                    ZStack(alignment: .top) {
                        VStack(spacing: 0) {
                            ForEach(Array(fundamentals.enumerated()), id: \.element.id) { index, fundamental in
                                FundamentalCardView(fundamental: fundamental, badgeSize: indexBadgeSize)
                                    .frame(height: geometry.size.height)
                                    .id(index)
                            }
                        }
                        .offset(y: -CGFloat(selectedIndex) * geometry.size.height + dragOffset)
                        .animation(.easeInOut(duration: 0.4), value: selectedIndex)
                        .gesture(
                            DragGesture(minimumDistance: 20)
                                .onChanged { value in
                                    dragOffset = value.translation.height
                                }
                                .onEnded { value in
                                    let threshold = geometry.size.height * 0.15
                                    _ = value.predictedEndLocation.y - value.location.y

                                    if value.translation.height < -threshold && selectedIndex < fundamentals.count - 1 {
                                        selectedIndex += 1
                                    } else if value.translation.height > threshold && selectedIndex > 0 {
                                        selectedIndex -= 1
                                    }
                                    dragOffset = 0
                                }
                        )
                    }
                    .ignoresSafeArea()
                }
                .ignoresSafeArea()
                .zIndex(0)

                // Floating index counter with menu
                ZStack {
                    if showIndexMenu {
                        Color.black.opacity(0.001)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showIndexMenu = false
                            }
                    }

                    VStack(alignment: .trailing, spacing: 0) {
                        HStack {
                            Spacer()

                            VStack(alignment: .trailing, spacing: 0) {
                                Button(action: {
                                    showIndexMenu.toggle()
                                }) {
                                    Text("\(selectedIndex + 1) / \(fundamentals.count)")
                                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(8)
                                        .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                                .background(
                                    GeometryReader { geometry in
                                        Color.clear
                                            .preference(key: BadgeSizePreferenceKey.self, value: geometry.size)
                                            .preference(key: ButtonWidthPreferenceKey.self, value: geometry.size.width)
                                    }
                                )
                                .onPreferenceChange(BadgeSizePreferenceKey.self) { newSize in
                                    if newSize != .zero {
                                        indexBadgeSize = newSize
                                    }
                                }
                                .onPreferenceChange(ButtonWidthPreferenceKey.self) { newWidth in
                                    counterButtonWidth = newWidth
                                }

                                if showIndexMenu {
                                    ScrollViewReader { scrollProxy in
                                        ScrollView {
                                            VStack(spacing: 0) {
                                                ForEach(0..<fundamentals.count, id: \.self) { index in
                                                    Button(action: {
                                                        selectedIndex = index
                                                        showIndexMenu = false
                                                    }) {
                                                        HStack {
                                                            Text("\(index + 1)")
                                                                .font(.system(size: 13, weight: .medium, design: .default))
                                                                .foregroundColor(index == selectedIndex ? .orange : .gray)

                                                            Spacer()

                                                            if index == selectedIndex {
                                                                Image(systemName: "checkmark")
                                                                    .foregroundColor(.orange)
                                                                    .font(.system(size: 11, weight: .semibold))
                                                            }
                                                        }
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .padding(.horizontal, 12)
                                                        .padding(.vertical, 10)
                                                        .background(index == selectedIndex ? Color.orange.opacity(0.12) : Color.clear)
                                                        .contentShape(Rectangle())
                                                    }
                                                    .buttonStyle(.plain)
                                                    .id(index)

                                                    if index < fundamentals.count - 1 {
                                                        Divider()
                                                            .background(Color.gray.opacity(0.15))
                                                            .padding(.horizontal, 8)
                                                    }
                                                }
                                            }
                                        }
                                        .onAppear {
                                            scrollProxy.scrollTo(selectedIndex, anchor: .top)
                                        }
                                    }
                                    .frame(height: CGFloat(min(fundamentals.count, maxVisibleItems)) * 44)
                                    .background(Color(red: 0.13, green: 0.13, blue: 0.13))
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                                    .padding(.top, 8)
                                    .frame(width: counterButtonWidth)
                                    .zIndex(1)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 60)

                        Spacer()
                    }
                    .allowsHitTesting(true)
                }
                .zIndex(1000)
            }
        }
        .onAppear {
            loadFundamentals()
        }
        .onChange(of: selectedIndex) { _, newValue in
            StorageManager.shared.saveLastIndex(newValue)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
                StorageManager.shared.saveLastIndex(selectedIndex)
            }
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

private struct BadgeSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

private struct ButtonWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ContentView()
}
