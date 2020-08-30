protocol DataManager {
    func getHotels() -> [Hotel]
    func save(details: HotelDetails)
    func save(hotel: Hotel)
    func getDetails(byId: Int) -> HotelDetails?
}
