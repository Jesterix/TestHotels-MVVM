import UIKit

protocol DataGetter {
    func getHotelListData(
        completion: @escaping (Result<[Hotel], Error>) -> Void
    )
    
    func getHotelDetails(
        for id: String,
        completion: @escaping (Result<HotelDetails, Error>) -> Void
    )
    
    func getHotelImage(
        imageName: String,
        completion: @escaping (Result<UIImage, Error>) -> Void
    )
}

