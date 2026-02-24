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
                TabView(selection: $selectedIndex) {
                    ForEach(Array(fundamentals.enumerated()), id: \.element.id) { index, fundamental in
                        FundamentalCardView(fundamental: fundamental)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
                
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
                    .padding(.top, 16)
                    
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
