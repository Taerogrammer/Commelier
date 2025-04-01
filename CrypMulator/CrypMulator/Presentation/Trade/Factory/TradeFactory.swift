//
//  TradeFactory.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import Foundation

struct TradeFactory {
    static func make(with market: String, type: OrderType) -> TradeViewController {


        // TODO: - File 생성 후 엔티티 바로 주입하기
        return TradeViewController(
            titleEntity: NavigationTitleEntity(imageURLString: nil, title: market),
            type: type)
    }
}
