//
//  ChartView.swift
//  CrypMulator
//
//  Created by 김태형 on 3/29/25.
//

import SwiftUI
import Charts

struct ChartListEntity: Identifiable {
    let id = UUID()
    let date: String
    let price: Double
}

struct ChartView: View {
    let data: [ChartListEntity]

    @State private var selectedIndex: Int?

    private let linearGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.accentColor.opacity(0.4),
            Color.accentColor.opacity(0.1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )

    private var xAxisLabelIndices: [Int] {
        let strideValue = max(data.count / 4, 1)
        var indices = Array(stride(from: 0, to: data.count, by: strideValue))
        if let last = indices.last, last != data.count - 1 {
            indices.append(data.count - 1)
        }
        return indices
    }

    var body: some View {
        GeometryReader { outerProxy in
            Chart {
                ForEach(data.indices, id: \.self) { index in
                    let entity = data[index]
                    LineMark(
                        x: .value("Index", index),
                        y: .value("가격", entity.price)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.blue)

                    AreaMark(
                        x: .value("Index", index),
                        y: .value("가격", entity.price)
                    )
                    .interpolationMethod(.cardinal)
                    .foregroundStyle(linearGradient)
                }

                if let selectedIndex, selectedIndex < data.count {
                    let selected = data[selectedIndex]

                    RuleMark(x: .value("Index", selectedIndex))
                        .foregroundStyle(.gray)
                        .lineStyle(StrokeStyle(lineWidth: 1))

                    PointMark(
                        x: .value("Index", selectedIndex),
                        y: .value("가격", selected.price)
                    )
                    .symbolSize(50)
                    .foregroundStyle(.red)
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let origin = geometry[proxy.plotAreaFrame].origin
                                    let locationX = value.location.x - origin.x
                                    if let index: Int = proxy.value(atX: locationX) {
                                        selectedIndex = min(max(index, 0), data.count - 1)
                                    }
                                }
                                .onEnded({ _ in
                                    selectedIndex = nil // 드래그 끝나면 초기화
                                })
                        )
                        .overlay(alignment: .topLeading) {
                            if let selectedIndex, selectedIndex < data.count {
                                let selected = data[selectedIndex]
                                let xPos = proxy.position(forX: selectedIndex) ?? 0
                                let yPos = proxy.position(forY: selected.price) ?? 0
                                let isRightSide = selectedIndex > data.count / 2

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(selected.date)")
                                        .bold()
                                    Text("\(FormatUtility.formattedPrice(selected.price)) \(StringLiteral.Currency.won)")
                                }
                                .font(.caption)
                                .padding(6)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .cornerRadius(8)
                                .offset(
                                    x: xPos + (isRightSide ? -120 : 8),
                                    y: yPos - 60
                                )
                            }
                        }
                }
            }
            .chartXAxis {
                AxisMarks(values: xAxisLabelIndices) { value in
                    if let i = value.as(Int.self), i < data.count {
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            Text(data[i].date)
                                .font(.caption2)
                        }
                    }
                }
            }
        }
    }
}
