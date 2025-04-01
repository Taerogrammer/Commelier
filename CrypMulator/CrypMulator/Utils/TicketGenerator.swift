//
//  TicketGenerator.swift
//  CrypMulator
//
//  Created by 김태형 on 3/30/25.
//

import Foundation

enum TicketGenerator {
    static func generate(prefix: String? = nil) -> String {
        let uuid = UUID().uuidString
        if let prefix = prefix {
            return "\(prefix)-\(uuid)"
        } else {
            return uuid
        }
    }
}
