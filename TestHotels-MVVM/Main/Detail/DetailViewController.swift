//
//  DetailViewController.swift
//  TestHotels
//
//  Created by Георгий Хайденко on 27.06.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    var detailView: DetailView!

    var hotel: Hotel
    var hotelDetails: HotelDetails
    var hotelImage: UIImage

    init(
        hotel: Hotel,
        details: HotelDetails,
        image: UIImage)
    {
        self.hotel = hotel
        self.hotelDetails = details
        self.hotelImage = image
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

        detailView.nameLabel.text = hotel.name
        detailView.imageView.image = hotelImage
        detailView.addressLabel.text = "Address: " + hotel.address
        detailView.lattitudeLabel.text = "Lattitude: \(hotelDetails.lat)"
        detailView.longtitudeLabel.text = "Longtitude: \(hotelDetails.lon)"
        detailView.distanceLabel.text =
            "Distance from center: " + String(hotel.distance)
        detailView.starsLabel.text = "⭐️: " + String(hotel.stars)
        detailView.suitesAvailableLabel.text = "Suites available: " +
            hotel.suitesAvailability.joined(separator: ", ")
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
}
