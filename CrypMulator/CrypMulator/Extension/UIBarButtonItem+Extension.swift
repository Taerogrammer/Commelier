//
//  UIBarButtonItem+Extension.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import Combine
import UIKit

extension UIBarButtonItem {
    var tapPublisher: AnyPublisher<Void, Never> {
        UIBarButtonItemPublisher(barButtonItem: self).eraseToAnyPublisher()
    }
}

// MARK: - Publisher
private struct UIBarButtonItemPublisher: Publisher {
    typealias Output = Void
    typealias Failure = Never

    let barButtonItem: UIBarButtonItem

    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
        let subscription = UIBarButtonItemSubscription(subscriber: subscriber, barButtonItem: barButtonItem)
        subscriber.receive(subscription: subscription)
    }
}

// MARK: - Subscription
private final class UIBarButtonItemSubscription<S: Subscriber>: NSObject, Subscription where S.Input == Void {
    private var subscriber: S?
    private weak var barButtonItem: UIBarButtonItem?

    init(subscriber: S, barButtonItem: UIBarButtonItem) {
        self.subscriber = subscriber
        self.barButtonItem = barButtonItem
        super.init()
        barButtonItem.target = self
        barButtonItem.action = #selector(didTapButton)
    }

    func request(_ demand: Subscribers.Demand) {
        // 수동 처리: 무시 가능
    }

    func cancel() {
        subscriber = nil
        barButtonItem?.target = nil
        barButtonItem?.action = nil
    }

    @objc private func didTapButton() {
        _ = subscriber?.receive(())
    }
}
