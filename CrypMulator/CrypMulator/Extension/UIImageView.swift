//
//  UIImageView.swift
//  CrypMulator
//
//  Created by 김태형 on 4/6/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setCoinImage(with imageURL: String?) {
        if let imageURL = imageURL {
            if imageURL.contains("http"), let url = URL(string: imageURL) {
                // 웹 이미지 로딩
                self.kf.setImage(
                    with: url,
                    placeholder: UIImage(systemName: "bitcoinsign.circle"),
                    options: [.transition(.fade(0.2))]
                )
            } else {
                // 로컬 이미지
                self.image = UIImage(named: imageURL) ?? UIImage(systemName: "bitcoinsign.circle")
            }
        } else {
            // imageURL 자체가 nil인 경우
            self.image = UIImage(systemName: "bitcoinsign.circle")
        }
    }
}
