import Foundation
import UIKit

class NetworkManager {
    var baseURL = URL(string: "https://raw.githubusercontent.com/Jesterix/TestHotelsFiles/master")
    var baseImageURL = URL(string: "https://github.com/Jesterix/TestHotelsFiles/raw/master")

    enum DataType: String {
        case json = ".json"
        case jpg = ".jpg"
    }

    enum URLError: Error {
        case invalidURL
    }

    private func makeURL(
        for object: String = "0777",
        dataType: DataType = .json
    ) throws -> URL {
        var baseUrl: URL? {
            switch dataType {
            case .json:
                return baseURL
            case .jpg:
                return baseImageURL
            }
        }
        
        guard var url = baseUrl else {
            throw URLError.invalidURL
        }
        
        url.appendPathComponent(object + dataType.rawValue)
        
        return url
    }

    private func getJSON<T: Decodable> (
        url: URL,
        _ completion: @escaping (Result<T, Error>) -> Void
    ) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(RequestError.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let result: T = try decoder.decode(
                    T.self,
                    from: data)
                completion(.success(result))
            } catch {
                completion(.failure(RequestError.invalidJson))
            }
        }.resume()
    }

    func getHotelListData(
        completion: @escaping (Result<[Hotel], Error>) -> Void
    ) {
        do {
            let url = try makeURL()
            getJSON(url: url) { (result: Result<[Hotel], Error>) in
                completion(result)
            }
        } catch let error {
            completion(.failure(error))
        }
    }

    func getHotelDetails(
        for id: String,
        completion: @escaping (Result<HotelDetails, Error>) -> Void
    ) {
        do {
            let url = try makeURL(
                for: id,
                dataType: .json)
            getJSON(url: url) { (result: Result<HotelDetails, Error>) in
                completion(result)
            }
        } catch let error {
            completion(.failure(error))
        }
    }

    func getHotelImage(
        imageName: String,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) {
        do {
            let url = try makeURL(
                for: imageName,
                dataType: .jpg)
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    completion(.failure(RequestError.invalidData))
                    return
                }
                guard let image = UIImage(data: data) else {
                    completion(.failure(RequestError.invalidImage))
                    return
                }
                completion(.success(image))

            }.resume()
        } catch let error {
            completion(.failure(error))
        }
    }
}

enum RequestError: Swift.Error, CustomStringConvertible {
    case invalidData
    case invalidJson
    case invalidImage

    public var description: String {
        switch self {
        case .invalidData: return "invalid data"
        case .invalidJson: return "invalid json"
        case .invalidImage: return "invalid or missing image"
        }
    }
}
