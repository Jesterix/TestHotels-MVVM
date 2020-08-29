//
//  Configurator.swift
//  TestHotels-MVVM
//
//  Created by Georgy Khaydenko on 29.08.2020.
//  Copyright © 2020 Georgy Khaydenko. All rights reserved.
//

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
