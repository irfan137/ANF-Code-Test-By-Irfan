//
//  ExploreCardViewModel.swift
//  ANF Code Test
//
//  Created by Irfan Mohammed on 10/24/25.
//


import UIKit
import SwiftUI

protocol ExploreCardViewModelDelegate: AnyObject {
    func didLoadCards()
    func didFailLoadingCards(error: Error)
}


class ExploreCardViewModel: ObservableObject {
    
    // MARK: - Properties
    
    weak var delegate: ExploreCardViewModelDelegate?
    
    @Published private(set) var exploreCards: [ExploreCard] = []
    private let networkService: NetworkServiceProtocol
    @Published private(set) var isLoading = false
    
    // MARK: - Computed Properties
    
    var numberOfCards: Int {
        return exploreCards.count
    }
    
    var isEmpty: Bool {
        return exploreCards.isEmpty
    }
    
    // MARK: - Initialization
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    
    func loadCards() {
        guard !isLoading else { return }
        
        isLoading = true
        
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            
            do {
                let cards = try await self.networkService.fetchExploreData()
                self.exploreCards = cards
                self.isLoading = false
                self.delegate?.didLoadCards()
            } catch {
                self.isLoading = false
                self.delegate?.didFailLoadingCards(error: error)
            }
        }
    }
    
    // Convenience method for SwiftUI
    var cards: [ExploreCard] {
        return exploreCards
    }
    
    func card(at index: Int) -> ExploreCard? {
        guard index >= 0 && index < exploreCards.count else {
            return nil
        }
        return exploreCards[index]
    }
    
    func loadImage(for card: ExploreCard) async -> UIImage? {
        return await networkService.loadImage(from: card.backgroundImage)
    }
}

