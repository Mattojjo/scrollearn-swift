//
//  ContentView.swift
//  scrollearn
//
//  Created by Leinad Suarez on 2/24/26.
//

import SwiftUI

struct ContentView: View {
    @State private var fundamentals: [Fundamental] = []
    @State private var selectedIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            if fundamentals.isEmpty {
                VStack(spacing: 16) {
                    ProgressView()
                        .tint(.cyan)
                    Text("Loading fundamentals...")
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.1, green: 0.1, blue: 0.2),
                            Color(red: 0.15, green: 0.15, blue: 0.25)
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
                                FundamentalCardView(fundamental: fundamental)
                                    .frame(height: geometry.size.height)
                            }
                        }
                        .offset(y: -CGFloat(selectedIndex) * geometry.size.height + dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation.height
                                }
                                .onEnded { value in
                                    let threshold = geometry.size.height * 0.1
                                    if value.translation.height < -threshold && selectedIndex < fundamentals.count - 1 {
                                        selectedIndex += 1
                                    } else if value.translation.height > threshold && selectedIndex > 0 {
                                        selectedIndex -= 1
                                    }
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        dragOffset = 0
                                    }
                                }
                        )
                    }
                    .ignoresSafeArea()
                }
                
                VStack {
                    HStack {
                        Text("Scrollearn")
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(selectedIndex + 1) / \(fundamentals.count)")
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    
                    Spacer()
                }
                .ignoresSafeArea()
            }
        }
        .onAppear {
            loadFundamentals()
        }
    }
    
    private func loadFundamentals() {
        fundamentals = FundamentalsManager.shared.loadFundamentals()
    }
}

#Preview {
    ContentView()
}
