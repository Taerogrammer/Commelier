//
//  BaseURL.swift
//  CrypMulator
//
//  Created by 김태형 on 3/30/25.
//

import Foundation

enum BaseURL {
    enum HTTPS {
        static let upbit = "https://api.upbit.com/v1"
        static let coingecko = "https://api.coingecko.com/api/v3"
    }
    enum WebSocket {
        static let upbitWebSocket = "wss://api.upbit.com/websocket/v1"
    }
}
