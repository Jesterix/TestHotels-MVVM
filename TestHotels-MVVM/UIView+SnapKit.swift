//
//  UIView+SnapKit.swift
//  TestHotels
//
//  Created by Георгий Хайденко on 25.06.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    var safeArea: UILayoutGuide {
        return self.safeAreaLayoutGuide
    }
}

extension UIView {
    func layout<T: UIView>(
        _ subview: T,
        _ closure: (ConstraintMaker) -> Void) -> T
    {
        self.addSubview(subview)
        subview.snp.makeConstraints(closure)
        return subview
    }

    var top: SnapKit.ConstraintItem {
        return snp.top
    }

    var bottom: SnapKit.ConstraintItem {
        return snp.bottom
    }

    var leading: SnapKit.ConstraintItem {
        return snp.leading
    }

    var trailing: SnapKit.ConstraintItem {
        return snp.trailing
    }

    var topMargin: SnapKit.ConstraintItem {
        return snp.topMargin
    }

    var bottomMargin: SnapKit.ConstraintItem {
        return snp.bottomMargin
    }

    var leadingMargin: SnapKit.ConstraintItem {
        return snp.leadingMargin
    }

    var trailingMargin: SnapKit.ConstraintItem {
        return snp.trailingMargin
    }
}

