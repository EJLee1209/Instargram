//
//  PaddingLabel.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/11.
//

import UIKit

class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 8.0, left: 12.0, bottom: 8.0, right: 12.0)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
