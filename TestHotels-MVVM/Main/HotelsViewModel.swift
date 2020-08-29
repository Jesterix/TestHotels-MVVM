import Bond

final class HotelsViewModel {
    let hotels = Observable<[Hotel]>([])
    let error = Observable<Error?>(nil)
    let refreshing = Observable<Bool>(false)
    
    private let dataManager: NetworkManager
    
    private let repository: Repository
    
    init(dataManager: NetworkManager, repository: Repository) {
        self.dataManager = dataManager
        self.repository = repository
    }
    
    func fetch() {
        refreshing.value = true
        
        dataManager.getHotelListData { result in
            switch result {
            case .success(let response):
                self.hotels.value = response
            case .failure(let error):
                self.error.value = error
            }
            self.refreshing.value = false
        }
    }
}
