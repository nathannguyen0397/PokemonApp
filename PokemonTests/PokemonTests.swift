//
//  PokemonTests.swift
//  PokemonTests
//
//  Created by Ngoc Nguyen on 8/8/23.
//

import XCTest
@testable import Pokemon
import Combine
final class PokemonTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSuccess(){
        let exp = expectation(description: "Success")
        var viewModel = ViewModel(service: MockService(filename: "responseSuccess"))
        viewModel.fetchAllPokemon()
        viewModel.$pokemonResponse
            .sink { response in
                XCTAssertEqual(response?.count ?? 0, 1281)
                exp.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [exp], timeout: 5.0)
    }
    
    func testFail(){
        let exp = expectation(description: "Expect nil response")
        var viewModel = ViewModel(service: MockService(filename: "responseFailure"))
        viewModel.fetchAllPokemon()
        viewModel.$pokemonResponse
            .sink { response in
                XCTAssertNil(response)
                exp.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [exp], timeout: 5.0)
    }
    
    

}

class MockService : ServiceProtocol{
    let filename : String
    
    init(filename: String) {
        self.filename = filename
    }
    
    func getAllPokemon() -> Future<PokemonResponse, Error> {
        return Future{[weak self] promise in
            guard let self = self, let url = Bundle(for: type(of: self)).url(forResource: filename, withExtension: "json")
            else {
                promise(.failure(APIError.invalidURL))
                return
            }
            
            let data = try! Data(contentsOf: url)
            do{
                let response = try JSONDecoder().decode(PokemonResponse.self, from: data)
                print(response)
                promise(.success(response))
            } catch {
                print(error)
                promise(.failure(APIError.decodingError))
            }
        }
    }
}
