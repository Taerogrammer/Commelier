//
//  SearchViewModel.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import RxCocoa
import RxSwift

final class SearchViewModel: ViewModel {

    private var searchText: String

    struct Input {

    }

    struct Output {

    }

    init(searchText: String) {
        self.searchText = searchText
    }

    func transform(input: Input) -> Output {


        return Output()
    }
}
