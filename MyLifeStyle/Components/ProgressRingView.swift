//
//  ProgressRingView.swift
//  MyLifeStyle
//
//  Created by Marcus Olsen Daatland on 02/10/2025.
//

import SwiftUI

struct ProgressRingView: View {
    var progress: Double
    var remaining: Int
    var showPercentage: Bool = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 20)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            VStack {
                if showPercentage {
                    Text("\(Int(progress * 100))%")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text("Fullført")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    Text("\(remaining)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Gjenværende")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(width: 150, height: 150)
        
    }
}
#Preview {
    VStack(spacing: 40) {
        ProgressRingView(progress: 0.65, remaining: 850, showPercentage: false)
            .previewDisplayName("NutritionView-stil")
        ProgressRingView(progress: 0.65, remaining: 850, showPercentage: true)
            .previewDisplayName("HomeView-stil (prosent)")
    }
}

