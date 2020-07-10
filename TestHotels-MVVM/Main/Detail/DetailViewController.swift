import UIKit

final class DetailViewController: UIViewController {
    var detailView: DetailView!
    var viewModel: DetailViewModel
    
    init(hotel: Hotel) {
        self.viewModel = DetailViewModel(
            dataManager: NetworkManager(),
            hotel: hotel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        detailView = DetailView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        bindViewModel()
        viewModel.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func bindViewModel() {
        viewModel.refreshing.bind(
            to: detailView.activityIndicator.reactive.isAnimating)
        viewModel.details.bind(to: self) { _, _ in
            self.setupData()
        }
        viewModel.image.bind(to: self) { _, _ in
            self.loadImage()
        }
    }
    
    func setupData() {
        detailView.nameLabel.text = viewModel.details.value?.name ?? viewModel.hotel.name
        detailView.addressLabel.text = "Address: \(viewModel.details.value?.address ?? viewModel.hotel.address)"
        detailView.distanceLabel.text = "Distance from center: \(viewModel.details.value?.distance ?? viewModel.hotel.distance)"
        detailView.starsLabel.text = "⭐️: \(viewModel.details.value?.stars ?? viewModel.hotel.stars)"
        detailView.suitesAvailableLabel.text = "Suites available: \(viewModel.details.value?.suitesAvailability.joined(separator: ", ") ?? viewModel.hotel.suitesAvailability.joined(separator: ", "))"
        
        detailView.lattitudeLabel.text = "Lattitude: \(viewModel.details.value?.lat ?? 0)"
        detailView.longtitudeLabel.text = "Longtitude: \(viewModel.details.value?.lon ?? 0)"
    }
    
    func loadImage() {
        detailView.imageView.image = viewModel.image.value.imageWithoutBorder(width: 1)
    }
}
