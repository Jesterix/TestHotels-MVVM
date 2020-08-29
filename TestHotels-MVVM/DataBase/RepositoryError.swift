//
//  RepositoryError.swift
//  TestHotels-MVVM
//
//  Created by Georgy Khaydenko on 29.08.2020.
//  Copyright © 2020 Georgy Khaydenko. All rights reserved.
//

import Foundation

public enum RepositoryError: Error {
    case UnknownError
    case UnauthorizedError
    
    static func error(fromRealmError error: Error) -> RepositoryError {
        return .UnknownError
    }
}
