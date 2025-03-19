//
//  BaseTableViewCell.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import UIKit

class BaseTableViewCell: UITableViewCell, ViewConfiguration {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }

    func configureLayout() { }

    func configureView() { }

}
