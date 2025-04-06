//
//  TransactionEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 3/29/25.
//

import UIKit

enum TransactionType {
    case buy
    case sell

    var title: String {
        switch self {
        case .buy: return "매수"
        case .sell: return "매도"
        }
    }

    var color: UIColor {
        switch self {
        case .buy: return SystemColor.red
        case .sell: return SystemColor.green
        }
    }
}

struct TransactionEntity {
    let type: TransactionType           // 매수/매도
    let market: String                  // 마켓명 (KRW-BTC 등)
    let transactionPrice: Double       // 체결 가격
    let quantity: Double               // 체결 수량
    let currencySymbol: String         // 통화 단위 (ex. BTC, ETH)
    let totalPrice: Double             // 총 거래 금액
    let date: Date                     // 체결 일시

    // MARK: - Display Properties

    var formattedTransactionPrice: String {
        FormatUtility.numberConverter(number: transactionPrice, style: .currency)
    }

    var formattedQuantity: String {
        "\(FormatUtility.rateConverter(number: quantity)) \(currencySymbol)"
    }

    var formattedTotalPrice: String {
        FormatUtility.numberConverter(number: totalPrice, style: .currency)
    }

    var formattedDate: String {
        FormatUtility.dateFormatter.string(from: date)
    }

    var title: String {
        type.title
    }

    var titleColor: UIColor {
        type.color
    }
}
