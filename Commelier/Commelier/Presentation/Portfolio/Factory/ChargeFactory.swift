//
//  ChargeFactory.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

struct ChargeFactory {
    private init() {}

    static func make(repository: ChargeRepositoryProtocol) -> ChargeViewController {
        let vm = ChargeViewModel(repository: repository)
        return ChargeViewController(viewModel: vm)
    }
}
