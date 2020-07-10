//
//  HotelCell.swift
//  TestHotels
//
//  Created by Георгий Хайденко on 26.06.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

class HotelCell: UITableViewCell {
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutContent(in: self)
        applyStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var nameLabel: UILabel!
    var distanceLabel: UILabel!
    var suitesAvailableLabel: UILabel!

    private func layoutContent(in view: UIView) {
        nameLabel = view.layout(UILabel())
        { make in
            make.leading.equalTo(safeArea).offset(10)
            make.top.equalTo(safeArea).offset(5)
            make.trailing.equalTo(safeArea).offset(-10)
        }

        distanceLabel = view.layout(UILabel())
        { make in
            make.top.equalTo(nameLabel.bottom).offset(5)
            make.leading.equalTo(nameLabel)
        }

        suitesAvailableLabel = view.layout(UILabel())
        { make in
            make.top.equalTo(nameLabel.bottom).offset(5)
            make.trailing.equalTo(nameLabel)
            make.leading.greaterThanOrEqualTo(distanceLabel.trailing).offset(5)
            make.bottom.equalTo(safeArea).offset(-5)
        }
    }

    private func applyStyle() {
        nameLabel.numberOfLines = 0
        distanceLabel.font = .systemFont(ofSize: 13)
        suitesAvailableLabel.font = .systemFont(ofSize: 13)
    }
}

