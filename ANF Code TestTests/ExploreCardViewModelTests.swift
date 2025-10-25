//
//  ExploreCardViewModelTests.swift
//  ANF Code TestTests
//
//  Created by Irfan Mohammed on 10/24/25.
//

import XCTest
@testable import ANF_Code_Test

class ExploreCardViewModelTests: XCTestCase {
    
    var viewModel: ExploreCardViewModel!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = ExploreCardViewModel(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func test_init_shouldHaveEmptyCards() {
        XCTAssertEqual(viewModel.numberOfCards, 0)
        XCTAssertTrue(viewModel.isEmpty)
    }
    
    func test_init_shouldNotBeLoading() {
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: - Load Cards Tests
    
    func test_loadCards_shouldSetIsLoadingToFalseAfterCompletion() {
        // Given
        let mockDelegate = MockExploreCardViewModelDelegate()
        viewModel.delegate = mockDelegate
        
        // When
        viewModel.loadCards()
        
        // Then
        let expectation = XCTestExpectation(description: "Loading completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertFalse(self.viewModel.isLoading, "ViewModel should not be loading after completion")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_loadCards_shouldCallDelegateOnSuccess() {
        // Given
        let mockDelegate = MockExploreCardViewModelDelegate()
        viewModel.delegate = mockDelegate
        
        // When
        viewModel.loadCards()
        
        // Then
        let expectation = XCTestExpectation(description: "Delegate called")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockDelegate.didLoadCardsCalled, "Delegate should be called on success")
            XCTAssertNil(mockDelegate.error, "Should not have error on success")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_loadCards_shouldUpdateCardsOnSuccess() {
        // Given
        let mockDelegate = MockExploreCardViewModelDelegate()
        viewModel.delegate = mockDelegate
        
        // When
        viewModel.loadCards()
        
        // Then
        let expectation = XCTestExpectation(description: "Cards loaded")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.numberOfCards, 10, "Should have 10 cards from mock JSON")
            XCTAssertFalse(self.viewModel.isEmpty, "Should not be empty")
            XCTAssertNotNil(self.viewModel.card(at: 0), "Should have first card")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_loadCards_shouldCallDelegateOnFailure() {
        // Given
        mockNetworkService.shouldFail = true
        let mockDelegate = MockExploreCardViewModelDelegate()
        viewModel.delegate = mockDelegate
        
        // When
        viewModel.loadCards()
        
        // Then
        let expectation = XCTestExpectation(description: "Error delegate called")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertFalse(mockDelegate.didLoadCardsCalled, "Should not call success delegate")
            XCTAssertNotNil(mockDelegate.error, "Should have error")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_loadCards_shouldNotLoadWhenAlreadyLoading() {
        // Given
        viewModel.loadCards()
        
        // When
        let initialLoadingState = viewModel.isLoading
        viewModel.loadCards() // Try to load again
        
        // Then
        XCTAssertEqual(viewModel.isLoading, initialLoadingState)
    }
    
    // MARK: - Card Retrieval Tests
    
    func test_cardAtIndex_shouldReturnNilForNegativeIndex() {
        // Given
        viewModel.loadCards()
        
        // Wait for cards to load
        let expectation = XCTestExpectation(description: "Wait for cards")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Then
            XCTAssertNil(self.viewModel.card(at: -1), "Should return nil for negative index")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_cardAtIndex_shouldReturnNilForOutOfBoundsIndex() {
        // Given
        viewModel.loadCards()
        
        // Wait for cards to load
        let expectation = XCTestExpectation(description: "Wait for cards")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Then
            let outOfBoundsIndex = self.viewModel.numberOfCards + 100
            XCTAssertNil(self.viewModel.card(at: outOfBoundsIndex), "Should return nil for out of bounds index")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_cardAtIndex_shouldReturnCorrectCard() {
        // Given
        viewModel.loadCards()
        
        // Wait for cards to load
        let expectation = XCTestExpectation(description: "Wait for cards")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Then
            let card = self.viewModel.card(at: 0)
            XCTAssertNotNil(card, "Should return a card")
            XCTAssertNotNil(card?.title, "Card should have a title")
            XCTAssertNotNil(card?.backgroundImage, "Card should have background image")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Convenience Methods Tests
    
    func test_cards_shouldReturnCardsArray() {
        // Given
        viewModel.loadCards()
        
        // Wait for cards to load
        let expectation = XCTestExpectation(description: "Wait for cards")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Then
            let cards = self.viewModel.cards
            XCTAssertEqual(cards.count, self.viewModel.numberOfCards, "Cards array should match numberOfCards")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock Network Service

class MockNetworkService: NetworkServiceProtocol {
    var shouldFail = false
    
    func fetchExploreData() async throws -> [ExploreCard] {
        if shouldFail {
            throw ExploreCardError.invalidURL
        }
        
        // Load from local JSON file
        guard let path = Bundle(for: type(of: self)).path(forResource: "exploreData", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let cards = try? JSONDecoder().decode([ExploreCard].self, from: data) else {
            throw ExploreCardError.invalidCode
        }
        
        return cards
    }
    
    func loadImage(from urlString: String) async -> UIImage? {
        // Return a simple mock image
        return UIImage(systemName: "star.fill")
    }
}

// MARK: - Mock Delegate

class MockExploreCardViewModelDelegate: ExploreCardViewModelDelegate {
    var didLoadCardsCalled = false
    var error: Error?
    
    func didLoadCards() {
        didLoadCardsCalled = true
    }
    
    func didFailLoadingCards(error: Error) {
        self.error = error
    }
}
