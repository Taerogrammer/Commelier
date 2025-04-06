//
//  UIControl+Extension.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import UIKit
import Combine

//RxCocoa 같은 구조가 Combine 에 없음
//Combine 프레임워크를 활용하여 UIKit의 UIControl(예: UIButton, UISwitch 등)에서 발생하는 이벤트를 반응형 스트림으로 변환
extension UIControl {
    func publisherForEvent(_ event: UIControl.Event) -> AnyPublisher<Void, Never> {
        return Publishers.ControlEvent(control: self, event: event)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}

extension Publishers {
    struct ControlEvent<Control: UIControl>: Publisher {
        typealias Output = Control
        typealias Failure = Never

        let control: Control
        let event: UIControl.Event

        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Control == S.Input {
            let subscription = ControlEventSubscription(control: control, event: event, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }

    private class ControlEventSubscription<Control: UIControl, S: Subscriber>: Subscription where S.Input == Control, S.Failure == Never {
        private var control: Control?
        private let event: UIControl.Event
        private var subscriber: S?

        init(control: Control, event: UIControl.Event, subscriber: S) {
            self.control = control
            self.event = event
            self.subscriber = subscriber
            control.addTarget(self, action: #selector(handleEvent), for: event)
        }

        @objc private func handleEvent(_ sender: UIControl) {
            _ = subscriber?.receive(sender as! Control)
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            control?.removeTarget(self, action: #selector(handleEvent), for: event)
            control = nil
            subscriber = nil
        }
    }
}
