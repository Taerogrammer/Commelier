//
//  TickerViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 3/25/25.
//

import RxCocoa
import RxSwift

final class TickerViewModel: ViewModel {
    let tickerListViewModel: TickerListViewModel
    private let disposeBag = DisposeBag()

    init(tickerListViewModel: TickerListViewModel) {
        self.tickerListViewModel = tickerListViewModel
    }

    struct Input {
        let listInput: TickerListViewModel.Input
    }

    struct Output {
        let error: Observable<APIError>
        let selectedItem: Observable<UpbitMarketEntity>
    }

    func transform(input: Input) -> Output {
        let listOutput = tickerListViewModel.transform(input: input.listInput)

        return Output(error: tickerListViewModel.errorStream,
                      selectedItem: listOutput.selectedItem)
    }
}
