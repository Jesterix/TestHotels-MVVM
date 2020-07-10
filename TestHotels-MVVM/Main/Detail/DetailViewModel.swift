import Bond
import UIKit

final class DetailViewModel {
    let details = Observable<HotelDetails?>(nil)
    let image = Observable<UIImage>(UIImage())
    let hotel: Hotel
    let error = Observable<Error?>(nil)
    let refreshing = Observable<Bool>(false)
    
    private let dataManager: NetworkManager
    
    init(
        dataManager: NetworkManager,
        hotel: Hotel
    ) {
        self.dataManager = dataManager
        self.hotel = hotel
    }
    
    func fetch() {
        refreshing.value = true
        
        dataManager.getHotelDetails(for: String(hotel.id)) { result in
            switch result {
            case .success(let response):
                self.details.value = response
            case .failure(let error):
                self.error.value = error
            }
            
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
}

