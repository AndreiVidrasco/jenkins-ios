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
    
    private func setup(){
        self.backgroundColor = Constants.UI.bigButtonColor
        self.tintColor = UIColor.white
    }
    
    override var isEnabled: Bool{
        didSet{
            self.backgroundColor = isEnabled ? Constants.UI.bigButtonColor : UIColor.lightGray
        }
    }
}
