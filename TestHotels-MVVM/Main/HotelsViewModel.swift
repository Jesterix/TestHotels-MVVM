import Bond
import Foundation

final class HotelsViewModel {
    let hotels = Observable<[Hotel]>([])
    let error = Observable<Error?>(nil)
    let refreshing = Observable<Bool>(false)
    
    private let networkManager: DataGetter
    
    private let repository: DataManager
    
    init(networkManager: DataGetter, repository: DataManager) {
        self.networkManager = networkManager
        self.repository = repository
    }
    
    func fetch() {
        refreshing.value = true
        
        networkManager.getHotelListData { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    response.forEach { self.repository.save(hotel: $0) }
                }
            case .failure(let error):
                self.error.value = error
            }
            
            DispatchQueue.main.async {
                self.getHotels()
                self.refreshing.value = false
            }
        }
    }
    
    private func getHotels() {
        hotels.value = repository.getHotels()
    }
}
