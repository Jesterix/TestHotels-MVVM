//
//  MainViewController.swift
//  TestHotels
//
//  Created by Георгий Хайденко on 25.06.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {

    var mainView: MainView!
    var hotels: [Hotel] = []
    var networkManager = NetworkManager()

    let reuseID = "hotelCell"

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

        loadData()

        mainView.switchControl.addTarget(
            self,
            action: #selector(sortHotels),
            for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    func loadData() {
        mainView.activityIndicator.startAnimating()
        networkManager.getHotelListData { result in
            DispatchQueue.main.async {
                self.mainView.activityIndicator.stopAnimating()
                switch result {
                case .success(let response):
                    self.hotels = response
                    self.mainView.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func loadDetails(
        for id: String,
        completion: @escaping (HotelDetails) -> Void)
    {
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
        completion: @escaping (UIImage) -> Void)
    {
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
            hotels.sort
                { $0.suitesAvailability.count < $1.suitesAvailability.count }
        } else {
            hotels.sort
                { $0.distance < $1.distance }
        }
        mainView.tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int
    {
        1
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        hotels.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseID) as? HotelCell else
        {
            fatalError("invalid cell type")
        }

        cell.nameLabel.text = hotels[indexPath.row].name
        cell.distanceLabel.text = "Distance from center: " + String(hotels[indexPath.row].distance)
        cell.suitesAvailableLabel.text =
        "Available suites: \(hotels[indexPath.row].suitesAvailability.count)"

        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
        mainView.activityIndicator.startAnimating()
        loadDetails(for: String(self.hotels[indexPath.row].id)) { details in
            guard let name = details.imageName else {
                self.mainView.activityIndicator.stopAnimating()
                self.navigationController?.pushViewController(
                DetailViewController(
                    hotel: self.hotels[indexPath.row],
                    details: details,
                    image: UIImage()),
                animated: true)
                return
            }

            self.loadImage(
            imageName: name) { image in
                self.mainView.activityIndicator.stopAnimating()
                self.navigationController?.pushViewController(
                DetailViewController(
                    hotel: self.hotels[indexPath.row],
                    details: details,
                    image: image.imageWithoutBorder(width: 1) ?? image),
                animated: true)
            }
        }
    }
}

