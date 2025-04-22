//
//  HoldingWidget.swift
//  HoldingWidget
//
//  Created by 김태형 on 4/21/25.
//

import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let holdings: [WidgetHoldingEntity]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), holdings: previewHoldings)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry(date: Date(), holdings: previewHoldings))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let defaults = UserDefaults(suiteName: "group.commelier.coin.holding")
        var holdings: [WidgetHoldingEntity] = []

        if let data = defaults?.data(forKey: "holdings"),
           let decoded = try? JSONDecoder().decode([WidgetHoldingEntity].self, from: data) {
            holdings = decoded
        }

        let entry = SimpleEntry(date: Date(), holdings: holdings)
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(1800)))
        completion(timeline)
    }

    private var previewHoldings: [WidgetHoldingEntity] {
        [
            WidgetHoldingEntity(symbol: "BTC", amount: Decimal(0.0)),
            WidgetHoldingEntity(symbol: "ETH", amount: Decimal(0.0)),
            WidgetHoldingEntity(symbol: "SOL", amount: Decimal(0.0))
        ]
    }
}

struct HoldingWidgetEntryView: View {
    var entry: SimpleEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                smallView
            case .systemMedium:
                mediumView
            case .systemLarge:
                unsupportedView
            default:
                unsupportedView
            }
        }
    }

    var smallView: some View {
        ZStack {
            // 전체 배경 카드 (크게 키움)
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)

            VStack(spacing: 10) {
                Text("💰 보유 코인")
                    .font(.caption2)
                    .foregroundColor(.secondary)

                Text("\(entry.holdings.count)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text("총 개수 기준")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.center)
            .padding(.vertical, 16)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(6) // 외곽 여백만 살짝
    }
    // MARK: - Medium View (정상 화면)
    var mediumView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("💰 보유량 Top 3")
                .font(.headline)

            HStack(spacing: 12) {
                ForEach(entry.holdings.prefix(3), id: \.self) { holding in
                    VStack(spacing: 6) {
                        Text(holding.symbol)
                            .font(.subheadline)
                            .bold()
                        Text(formatDecimal(holding.amount))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.secondarySystemBackground)))
                }
            }

            Spacer()
        }
        .padding()
    }

    // MARK: - 미지원 사이즈 안내
    var unsupportedView: some View {
        VStack(spacing: 8) {
            Text("🚫 해당 사이즈는")
                .font(.headline)
            Text("위젯에서 지원하지 않습니다.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }

    // MARK: - Formatter
    private func formatDecimal(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 4
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        return formatter.string(for: value) ?? "-"
    }
}

struct HoldingWidget: Widget {
    let kind: String = "HoldingWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HoldingWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HoldingWidgetEntryView(entry: entry)
                    .padding()
                    .background(Color(.systemBackground))
            }
        }
        .configurationDisplayName("보유 코인 위젯")
        .description("가장 많이 보유한 코인을 확인하세요.")
    }
}

//#Preview(as: .systemSmall) {
//    HoldingWidget()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
