//
//  ChartView.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/9/25.
//

import SwiftUI
import Charts

struct ChartView: View {
    let priceData: [Double]
    let linearGradient = LinearGradient(gradient: Gradient(colors: [
        Color.accentColor.opacity(0.4),
        Color.accentColor.opacity(0.1)]),
                                        startPoint: .top,
                                        endPoint: .bottom)
    var filteredData: [Double] {
        stride(from: 0, to: priceData.count, by: 5).map { index in priceData[index] }
    }

    var body: some View {
        Chart {
            ForEach(filteredData.indices, id: \.self) { index in
                LineMark(
                    x: .value("", index),
                    y: .value("Price", filteredData[index]))
                .foregroundStyle(.blue)
                .interpolationMethod(.catmullRom)
                AreaMark(
                    x: .value("", index),
                    y: .value("Price", filteredData[index]))
                .interpolationMethod(.cardinal)
                .foregroundStyle(linearGradient)
            }
        }
        .padding()
    }
}
