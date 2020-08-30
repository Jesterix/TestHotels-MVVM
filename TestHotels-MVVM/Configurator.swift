final class Configurator {
    private let networkManager = NetworkManager()
    private let repository = Repository()
    
    public func createMain() -> MainViewController {
        return MainViewController(viewModel: HotelsViewModel(
            dataManager: networkManager,
            repository: repository))
    }
    
    public func createDetail(with hotel: Hotel) -> DetailViewController {
        return DetailViewController(viewModel: DetailViewModel(
            dataManager: networkManager,
            repository: repository,
            hotel: hotel))
    }
}
