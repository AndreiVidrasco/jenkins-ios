//
//  FavoriteCollectionViewCell.swift
//  JenkinsiOS
//
//  Created by Robert on 22.06.17.
//  Copyright © 2017 MobiLab Solutions. All rights reserved.
//

import UIKit
import QuartzCore

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var healthImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var colorBackgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buildStabilityLabel: UILabel!
    @IBOutlet weak var buildStabilityContentLabel: UILabel!
    @IBOutlet weak var lastBuildLabel: UILabel!
    
    let dateFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.maximumUnitCount = 2
        formatter.unitsStyle = .full
        return formatter
    }()

    private var gradientLayer: CAGradientLayer?

    private func setup() {
        colorBackgroundView.backgroundColor = .clear

        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
        
        self.containerView.layer.borderColor = Constants.UI.paleGreyColor.cgColor
        self.containerView.layer.borderWidth = 1

        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = colorBackgroundView.bounds
        let gradientLayerFrame = gradientLayer!.frame
        gradientLayer?.startPoint = CGPoint(x: gradientLayerFrame.maxX, y: gradientLayerFrame.minY)
        gradientLayer?.endPoint = CGPoint(x: gradientLayerFrame.minX, y: gradientLayerFrame.maxY)
        self.colorBackgroundView.layer.insertSublayer(gradientLayer!, at: 0)
        
        healthImageView.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    var favoritable: Favoratible? {
        didSet{
            if let job = favoritable as? Job {
                setupForJob(job: job)
            }
            else if let build = favoritable as? Build {
                setupForBuild(build: build)
            }
            else {
                empty()
            }
        }
    }

    func setLoading() {
        nameLabel.text = "Loading favorite"
        buildStabilityLabel.text = "Build Stability"
        buildStabilityContentLabel.text = "..."
        lastBuildLabel.text = "..."
        setGradientLayerColor(with: UIColor.lightGray.withAlphaComponent(0.7))
    }

    func setErrored() {
        nameLabel.text = "Loading favorite failed"
        buildStabilityLabel.text = ""
        buildStabilityContentLabel.text = ""
        lastBuildLabel.text = ""
        setGradientLayerColor(with: UIColor.darkGray)
    }

    private func setupForJob(job: Job){
        
        if let imageName = job.healthReport.first?.iconClassName {
            healthImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            healthImageView.tintColor = .white
        }
        else {
            healthImageView.image = nil
        }
        
        nameLabel.text = job.name
        buildStabilityLabel.text = "Build Stability"
        buildStabilityContentLabel.text = job.healthReport.first?.description
        
        if let timeStamp = job.lastBuild?.timeStamp, let describingString = dateFormatter.string(from: timeStamp, to: Date()) {
            lastBuildLabel.text = describingString + " ago"
        }
        else {
            lastBuildLabel.text = ""
        }
        
        setGradientLayerColor(with: job.describingColor())
    }

    private func setupForBuild(build: Build) {
        nameLabel.text = build.fullDisplayName ?? build.displayName ?? "Unknown"
        buildStabilityLabel.text = "Build Duration"
        
        if let timeStamp = build.timeStamp, let describingString = dateFormatter.string(from: timeStamp, to: Date()) {
            lastBuildLabel.text = describingString + " ago"
        }
        else {
            lastBuildLabel.text = ""
        }
        
        buildStabilityContentLabel.text = build.duration?.toString() ?? "Unknown"
        
        setGradientLayerColor(with: build.describingColor())
    }

    private func empty() {
        nameLabel.text = ""
        setGradientLayerColor(with: .clear)
    }

    private func setGradientLayerColor(with baseColor: UIColor) {
        gradientLayer?.colors = [baseColor.withAlphaComponent(0.7).cgColor, baseColor.withAlphaComponent(0.6).cgColor]
    }
}
