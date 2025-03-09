//
//  DetailViewModel.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import RxCocoa
import RxSwift

final class DetailViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    private let id: Observable<String>

    enum SettingAction {
        case popViewController
    }

    struct Input {
        let barButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let action: PublishRelay<SettingAction>
        let data: Observable<[CoingeckoCoinResponse]>
        let detailData: PublishRelay<[Section]>
    }

    init(id: String) {
        self.id = Observable.just(id)
    }

    func transform(input: Input) -> Output {
        let action = PublishRelay<SettingAction>()
        let result = PublishRelay<[CoingeckoCoinResponse]>()
        let detailResult = PublishRelay<[Section]>()

        input.barButtonTapped
            .bind(with: self) { owner, _ in
                action.accept(SettingAction.popViewController)
            }
            .disposed(by: disposeBag)

        id
            .flatMapLatest { id -> Single<[CoingeckoCoinResponse]> in
                return NetworkManager.shared.getItem(
                    api: CoingeckoRouter.getCoinInformation(ids: id),
                    type: [CoingeckoCoinResponse].self)
            }
            .bind(with: self) { owner, data in
                result.accept(data)
            }
            .disposed(by: disposeBag)

        result
            .asObservable()
            .map { $0.first }
            .subscribe(with: self) { owner, result in
                detailResult.accept([
                    Section(name: "종목정보", items: [
                        Information(title: "24시간 고가", money: result?.high_24h_description ?? "", date: ""),
                        Information(title: "24시간 저가", money: result?.low_24h_description ?? "", date: ""),
                        Information(title: "역대 최고가", money: result?.ath_description ?? "", date: result?.ath_date_description ?? ""),
                        Information(title: "역대 최소가", money: result?.atl_description ?? "", date: result?.atl_date_description ?? "")
                    ]),
                    Section(name: "투자지표", items: [
                        Information(title: "시가총액", money: result?.market_cap_description ?? "", date: ""),
                        Information(title: "완전 희석 가치(FDV)", money: result?.fully_diluted_valuation_description ?? "", date: ""),
                        Information(title: "총 거래량", money: result?.total_volume_description ?? "", date: "")
                    ])
                ])
            }
            .disposed(by: disposeBag)

        return Output(
            action: action,
            data: result.asObservable(),
            detailData: detailResult)
    }
}
