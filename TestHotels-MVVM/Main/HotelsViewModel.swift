import Bond
import Foundation

final class HotelsViewModel {
    let hotels = Observable<[Hotel]>([])
    let error = Observable<Error?>(nil)
    let refreshing = Observable<Bool>(false)
    
    private let dataManager: NetworkManager
    
    private let repository: DataManager
    
    init(dataManager: NetworkManager, repository: DataManager) {
        self.dataManager = dataManager
        self.repository = repository
    }
    
    func fetch() {
        refreshing.value = true
        
        dataManager.getHotelListData { result in
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
