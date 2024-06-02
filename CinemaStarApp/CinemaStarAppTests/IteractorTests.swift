//
//  IteractorTests.swift
//  CinemaStarAppTests
//
//  Created by MacBookPro on 02.06.2024.
//

import XCTest
import Combine
@testable import CinemaStarApp


final class NetworkServiceMock: NetworkProtocol {
    var detailResult: AnyPublisher<MovieDetail, Error>?
        var imageResult: AnyPublisher<Data, Never>?
        
        func fetchMovies() -> AnyPublisher<[Movie], Error> {
            fatalError("Not implemented")
        }
        
        func fetchDetail(id: Int) -> AnyPublisher<MovieDetail, Error> {
            if let result = detailResult {
                return result
            } else {
                fatalError("detailResult not set")
            }
        }
        
        func fetchImage(url: URL) -> AnyPublisher<Data, Never> {
            if let result = imageResult {
                return result
            } else {
                fatalError("imageResult not set")
            }
        }
    
}

final class IteractorTests: XCTestCase {
    var sut: DetailViewIteractor!
    var mockNetworkService: NetworkServiceMock!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockNetworkService = NetworkServiceMock()
        sut = DetailViewIteractor(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        cancellables = []
        super.tearDown()
    }
    
    func testGetDetails() {

        let id = 123
        let expectedDetails = MovieDetail(dto: DetailMovieDto(poster: PosterDto(url: "", previewUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTG9cc7kG51Ul3gqaeKJaTSn0Y7BCWfArrRCA&s"), name: "test" , rating: RatingDto(kp: 2.2), description: "sdvsdv", year: 1231, countries: nil, type: "sdvs", persons: nil, spokenLanguages: nil, similarMovies: nil))
        mockNetworkService.detailResult = Just(expectedDetails).setFailureType(to: Error.self).eraseToAnyPublisher()
        

        var receivedDetails: MovieDetail?
        let expectation = self.expectation(description: "Completion")
        sut.getDetails(id: id) { details in
            receivedDetails = details
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0) { error in
            XCTAssertNil(error)
        }
    }
    
    func testGetImage() {
        let expectedData = Data(base64Encoded: "SGVsbG8gV29ybGQ=")!
        mockNetworkService.imageResult = Just(expectedData).eraseToAnyPublisher()

        var receivedData: Data?
        let expectation = self.expectation(description: "Completion")
        sut.getImage(url: "https://example.com/image.jpg")
            .sink { data in
                receivedData = data
                expectation.fulfill()
            }
            .store(in: &cancellables)
    
        waitForExpectations(timeout: 1.0) { error in
            XCTAssertNil(error)
            XCTAssertEqual(receivedData, expectedData)
        }
    }
}
