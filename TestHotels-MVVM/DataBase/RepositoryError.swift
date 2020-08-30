import Foundation

public enum RepositoryError: Error {
    case UnknownError
    case UnauthorizedError
    
    static func error(fromRealmError error: Error) -> RepositoryError {
        return .UnknownError
    }
}
