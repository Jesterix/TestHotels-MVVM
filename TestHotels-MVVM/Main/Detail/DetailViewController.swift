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
        
        detailView.nameLabel.text = viewModel.hotel.name
//        detailView.imageView.image = hotelImage
        detailView.addressLabel.text = "Address: " + viewModel.hotel.address
//        detailView.lattitudeLabel.text = "Lattitude: \(hotelDetails.lat)"
//        detailView.longtitudeLabel.text = "Longtitude: \(hotelDetails.lon)"
        detailView.distanceLabel.text =
            "Distance from center: " + String(viewModel.hotel.distance)
        detailView.starsLabel.text = "⭐️: " + String(viewModel.hotel.stars)
        detailView.suitesAvailableLabel.text = "Suites available: " +
            viewModel.hotel.suitesAvailability.joined(separator: ", ")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
}
