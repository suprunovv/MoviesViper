
import SwiftUI

protocol DetailRouterProtocol {
    var entry: StartPoint? { get set }
    static func createDetailModule(movieId: Int) -> DetailRouterProtocol
    func back()
}

final class DetailRouter: DetailRouterProtocol {
    var entry: StartPoint?
    
    static func createDetailModule(movieId: Int) -> DetailRouterProtocol {
        let router = DetailRouter()
        let networkService = NetworkService()
        let iteractor = DetailViewIteractor(networkService: networkService)
        let presenter = DetailViewPresenter(movieId: String(movieId), iteractor: iteractor, router: router)
        let view = DetailView(presenter: presenter)
        let chaildView = UIHostingController(rootView: view)
        router.entry = chaildView
        return router
    }
    
    func back() {
        self.entry?.navigationController?.popViewController(animated: true)
    }
}
