//
//  BasicImageTableViewCell.swift
//  JenkinsiOS
//
//  Created by Robert on 10.08.18.
//  Copyright © 2018 MobiLab Solutions. All rights reserved.
//

import UIKit

class BasicImageTableViewCell: UITableViewCell {
    @IBOutlet var container: UIView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        container.layer.cornerRadius = 5
        container.layer.borderColor = Constants.UI.paleGreyColor.cgColor
        container.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.1) {
                self.setBackgroundColor(for: selected)
            }
        } else {
            setBackgroundColor(for: selected)
        }
    }

    private func setBackgroundColor(for selected: Bool) {
        container.backgroundColor = selected ? UIColor.lightGray.withAlphaComponent(0.3) : .white
    }
}
