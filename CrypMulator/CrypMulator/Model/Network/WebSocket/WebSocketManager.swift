//
//  WebSocketManager.swift
//  CrypMulator
//
//  Created by 김태형 on 3/30/25.
//

import Combine
import UIKit

final class WebSocketManager: WebSocketProvider {
    static let shared = WebSocketManager()
    private init() { }

    private var webSocket: URLSessionWebSocketTask?

    private let orderbookSubject = PassthroughSubject<OrderBookEntity, Never>()
    private let livePriceSubject = PassthroughSubject<LivePriceEntity, Never>()

    var orderbookPublisher: AnyPublisher<OrderBookEntity, Never> {
        orderbookSubject.eraseToAnyPublisher()
    }

    var tickerPublisher: AnyPublisher<LivePriceEntity, Never> {
        livePriceSubject.eraseToAnyPublisher()
    }

    // 연결
    func connect() {
        guard let url = URL(string: BaseURL.WebSocket.upbitWebSocket) else { return }

        // shared는 한 번 호출이기 때문에 지속적인 연결에 적절하지 않음
        let session = URLSession(configuration: .default)
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()

        receiveMessage()
    }

    func send(market: String) {
        let ticket = TicketGenerator.generate(prefix: "iOS")

        let payload: [[String: Any]] = [
            ["ticket": ticket],
            ["type": "orderbook", "codes": [market]],
            ["type": "ticker", "codes": [market]]
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            print("JSON serialization failed")
            return
        }


        webSocket?.send(.data(jsonData)) { error in
            if let error = error {
                print("Send Error:", error)
            } else {
                print("✅ Sent payload with ticket: \(ticket)")
            }
        }
    }

    private func receiveMessage() {
        webSocket?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    self?.handleMessageData(data)
                default:
                    break
                }

            case .failure(let error):
                print("Receive error: \(error)")
            }

            self?.receiveMessage() // 재귀 호출로 지속 수신
        }
    }

    private func handleMessageData(_ data: Data) {
        // 먼저 type만 파싱하기 위한 구조
        struct MessageTypeDTO: Decodable {
            let type: String
        }

        guard let typeInfo = try? JSONDecoder().decode(MessageTypeDTO.self, from: data) else {
            print("❌ Unknown message format")
            return
        }

        switch typeInfo.type {
        case "orderbook":
            do {
                let orderBook = try JSONDecoder().decode(OrderBookDTO.self, from: data)
                orderbookSubject.send(orderBook.toEntity())
            } catch {
                print("❌ OrderBook decoding error:", error)
            }

        case "ticker":
            do {
                let ticker = try JSONDecoder().decode(TickerDTO.self, from: data)
                livePriceSubject.send(ticker.toLivePrice())
            } catch {
                print("❌ Ticker decoding error:", error)
            }

        default:
            print("❓ Unsupported type:", typeInfo.type)
        }
    }

    func disconnect() {
        webSocket?.cancel(with: .goingAway, reason: nil)
        webSocket = nil
    }
}
