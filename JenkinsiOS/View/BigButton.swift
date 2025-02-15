//
//  BigButton.swift
//  JenkinsiOS
//
//  Created by Robert on 31.10.16.
//  Copyright © 2016 MobiLab Solutions. All rights reserved.
//

import UIKit

@IBDesignable class BigButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        backgroundColor = Constants.UI.skyBlue
        tintColor = UIColor.white
        layer.cornerRadius = 5
    }

    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? Constants.UI.skyBlue : Constants.UI.silver
        }
    }
}
