//
//  TickerFactory.swift
//  CrypMulator
//
//  Created by 김태형 on 3/30/25.
//

import UIKit

struct TickerFactory {
    private init() {}
    static func make() -> TickerViewController {
        let listVM = TickerListViewModel()
        let vm = TickerViewModel(tickerListViewModel: listVM)
        return TickerViewController(tickerViewModel: vm)
    }
}
