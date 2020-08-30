import Bond
import UIKit
import Foundation

final class DetailViewModel {
    let details = Observable<HotelDetails?>(nil)
    let image = Observable<UIImage>(UIImage())
    let hotel: Hotel
    let error = Observable<Error?>(nil)
    let refreshing = Observable<Bool>(false)
    
    private let dataManager: NetworkManager
    
    private let repository: DataManager
    
    init(
        dataManager: NetworkManager,
        repository: DataManager,
        hotel: Hotel
    ) {
        self.dataManager = dataManager
        self.repository = repository
        self.hotel = hotel
    }
    
    func fetch() {
        refreshing.value = true
        
        dataManager.getHotelDetails(for: String(hotel.id)) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.repository.save(details: response)
                }
                
            case .failure(let error):
                self.error.value = error
            }
            
            DispatchQueue.main.async {
                self.getHotelDetails()
                self.downloadImage()
            }
        }
    }
    
    private func getHotelDetails() {
        guard let detailsById: HotelDetails = repository.getDetails(byId: hotel.id) else {
                return
        }
        details.value = detailsById
    }
    
    private func downloadImage() {
        guard let imageName = self.details.value?.imageName else {
            self.refreshing.value = false
            return
        }
        
        self.dataManager.getHotelImage(imageName: imageName) { result in
            switch result {
            case .success(let image):
                self.image.value = image
            case .failure(let error):
                self.error.value = error
            }
            self.refreshing.value = false
        }
    }
}

