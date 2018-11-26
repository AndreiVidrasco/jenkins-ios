//
//  Errors.swift
//  JenkinsiOS
//
//  Created by Robert on 23.09.16.
//  Copyright © 2016 MobiLab Solutions. All rights reserved.
//

import Foundation

enum NetworkManagerError: Error {
    case JSONParsingFailed
    case HTTPResponseNoSuccess(code: Int, message: String)
    case dataTaskError(nsError: NSError)
    case noDataFound
    case URLBuildingError

    var localizedDescription: String {
        switch self {
        case .JSONParsingFailed:
            return "JSON Parsing Failed"
        case let .HTTPResponseNoSuccess(code, message):
            return message + "\(code)"
        case let .dataTaskError(error):
            return error.localizedDescription
        case .noDataFound:
            return "No data found"
        case .URLBuildingError:
            return "Cannot build url"
        }
    }

    var code: Int {
        switch self {
        case .JSONParsingFailed: return -2000
        case let .HTTPResponseNoSuccess(code, _): return code
        case let .dataTaskError(error): return error.code
        case .noDataFound: return -3000
        case .URLBuildingError: return -4000
        }
    }
}

enum BuildError: Error {
    case notEnoughDataError

    var localizedDescription: String {
        switch self {
        case .notEnoughDataError: return "Not enough data"
        }
    }
}

enum AccountManagerError: Error {
    case accountAlreadyExists
    case urlEncodingError

    var localizedDescription: String {
        switch self {
        case .accountAlreadyExists:
            return "An account with that url already exists"
        case .urlEncodingError:
            return "Could not properly encode the given url"
        }
    }
}

enum ParsingError: Error {
    case DataNotCorrectFormatError
    case KeyMissingError(key: String)

    var localizedDescription: String {
        switch self {
        case .DataNotCorrectFormatError:
            return "The data is not in a correct format"
        case let .KeyMissingError(key):
            return "The key \(key) is missing in the JSON"
        }
    }
}
