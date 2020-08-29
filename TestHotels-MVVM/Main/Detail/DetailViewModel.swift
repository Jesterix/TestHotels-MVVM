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
    
    private let repository: Repository
    
    init(
        dataManager: NetworkManager,
        repository: Repository,
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
                    self.repository.save(RealmHotelDetails(from: response))
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
        guard let detailsById: RealmHotelDetails = repository.getEntity(byId: hotel.id) else {
                return
        }
        details.value = detailsById.converted()
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

