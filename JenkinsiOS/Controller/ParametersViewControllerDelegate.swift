//
//  ParametersViewControllerDelegate.swift
//  JenkinsiOS
//
//  Created by Robert on 30.10.16.
//  Copyright © 2016 MobiLab Solutions. All rights reserved.
//

import Foundation

protocol ParametersViewControllerDelegate {
    func build(parameters: [ParameterValue], completion: @escaping (JobListQuietingDown?, Error?) -> Void)
    func updateAccount(data: [String: String?])
}
