final class Configurator {
    private var serviceLocator = ServiceLocator()

    init() {
        serviceLocator.registerService(service: NetworkManager() as DataGetter)
        serviceLocator.registerService(service: Repository() as DataManager)
    }
    
    public func createMain() -> MainViewController {
        return MainViewController(viewModel: HotelsViewModel(
            networkManager: serviceLocator.getService(),
            repository: serviceLocator.getService()))
    }
    
    public func createDetail(with hotel: Hotel) -> DetailViewController {
        return DetailViewController(viewModel: DetailViewModel(
            networkManager: serviceLocator.getService(),
            repository: serviceLocator.getService(),
            hotel: hotel))
    }
}
