import UIKit

final class MainViewController: UIViewController {
    var mainView: MainView!
    var networkManager = NetworkManager()
    
    private var viewModel: HotelsViewModel
    
    let reuseID = "hotelCell"
    
    init(viewModel: HotelsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        mainView = MainView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(
            HotelCell.self,
            forCellReuseIdentifier: reuseID)
        
        bindViewModel()
        viewModel.fetch()
        
        mainView.switchControl.addTarget(
            self,
            action: #selector(sortHotels),
            for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func bindViewModel() {
        viewModel.refreshing.bind(
            to: mainView.activityIndicator.reactive.isAnimating)
        viewModel.hotels.bind(to: self) { _, _ in
            self.mainView.tableView.reloadData()
        }
    }
    
    func loadDetails(
        for id: String,
        completion: @escaping (HotelDetails) -> Void
    ) {
        networkManager.getHotelDetails(for: id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    completion(response)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func loadImage(
        imageName: String,
        completion: @escaping (UIImage) -> Void
    ) {
        networkManager.getHotelImage(imageName: imageName) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    completion(response)
                case .failure(let error):
                    completion(UIImage())
                    print(error)
                }
            }
        }
    }
    
    @objc func sortHotels() {
        if mainView.switchControl.isOn {
            viewModel.hotels.value.sort
                { $0.suitesAvailability.count < $1.suitesAvailability.count }
        } else {
            viewModel.hotels.value.sort
                { $0.distance < $1.distance }
        }
        mainView.tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.hotels.value.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseID) as? HotelCell else {
                fatalError("invalid cell type")
        }
        
        cell.nameLabel.text = viewModel.hotels.value[indexPath.row].name
        cell.distanceLabel.text = "Distance from center: " + String(viewModel.hotels.value[indexPath.row].distance)
        cell.suitesAvailableLabel.text = "Available suites: \(viewModel.hotels.value[indexPath.row].suitesAvailability.count)"
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        self.navigationController?.pushViewController(
            DetailViewController(hotel: self.viewModel.hotels.value[indexPath.row]),
            animated: true)
    }
}

