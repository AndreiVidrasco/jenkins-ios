//
//  Account.swift
//  JenkinsiOS
//
//  Created by Robert on 25.09.16.
//  Copyright © 2016 MobiLab Solutions. All rights reserved.
//

import Foundation

class Account: NSObject, NSCoding {
    /// The account's name
    var displayName: String?
    /// The account's base url
    var baseUrl: URL
    /// The username that should be used for any request
    var username: String?
    /// The password that should be used for any request
    var password: String?
    /// The port that should be used for any request
    var port: Int?
    /// Whether or not the requests made for that account should trust all certificates
    var trustAllCertificates: Bool

    /// Initializer for Account
    ///
    /// - parameter baseUrl:     The account's base url
    /// - parameter username:    The username that should be used for any request
    /// - parameter password:    The password that should be used for any request
    /// - parameter port:        The port that should be used for any request
    /// - parameter displayName: The account's name
    ///
    /// - returns: An initialised Account object
    init(baseUrl: URL, username: String?, password: String?, port: Int?, displayName: String?, trustAllCertificates: Bool = false) {
        self.displayName = displayName
        self.baseUrl = baseUrl
        self.username = username
        self.password = password
        self.port = port
        self.trustAllCertificates = trustAllCertificates
    }

    required init?(coder aDecoder: NSCoder) {
        guard let baseUrl = aDecoder.decodeObject(forKey: "baseUrl") as? URL
        else { return nil }

        self.baseUrl = baseUrl
        port = aDecoder.decodeObject(forKey: "port") as? Int
        username = aDecoder.decodeObject(forKey: "username") as? String
        displayName = aDecoder.decodeObject(forKey: "displayName") as? String
        trustAllCertificates = aDecoder.decodeBool(forKey: "trustAllCertificates")
    }

    /// Encode an account object
    ///
    /// - parameter aCoder: The coder that should be used to encode the account
    func encode(with aCoder: NSCoder) {
        aCoder.encode(baseUrl, forKey: "baseUrl")
        aCoder.encode(port, forKey: "port")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(displayName, forKey: "displayName")
        aCoder.encode(trustAllCertificates, forKey: "trustAllCertificates")
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let otherAccount = object as? Account
        else { return false }
        return baseUrl == otherAccount.baseUrl && username == otherAccount.username
            && password == otherAccount.password && port == otherAccount.port
            && trustAllCertificates == otherAccount.trustAllCertificates
    }

    override func copy() -> Any {
        return Account(baseUrl: baseUrl, username: username, password: password, port: port, displayName: displayName, trustAllCertificates: trustAllCertificates)
    }
}
