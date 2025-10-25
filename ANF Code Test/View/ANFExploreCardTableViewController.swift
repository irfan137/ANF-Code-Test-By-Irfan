//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit

class ANFExploreCardTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let viewModel = ExploreCardViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupTableView()
        loadData()
    }
    
    // MARK: - Setup
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func setupTableView() {
        // Register custom UIKit cell
        tableView.register(ExploreCardCell.self, forCellReuseIdentifier: "ExploreCardCell")
        
        // Configure table view
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        tableView.separatorStyle = .none
    }
    
    private func loadData() {
        viewModel.loadCards()
    }
    
    // MARK: - Error Handling
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Network Error",
            message: "Failed to load explore content. Please check your internet connection.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.loadData()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    // MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCards
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreCardCell", for: indexPath) as! ExploreCardCell
        
        guard let card = viewModel.card(at: indexPath.row) else {
            return cell
        }
        
        // Configure cell with card data (no image yet)
        cell.configure(with: card, image: nil)
        
        // Load image asynchronously
        Task { @MainActor [weak self, weak cell] in
            guard let self = self, let cell = cell else { return }
            
            let image = await self.viewModel.loadImage(for: card)
            
            // Only update if cell is still showing the same card
            guard cell.isDisplaying(card: card) else {
                return
            }
            
            // Update image by calling configure again with the image
            cell.configure(with: card, image: image)
            
            // Reload the row to update height with animation
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        
        return cell
    }
}

// MARK: - ExploreCardViewModelDelegate

extension ANFExploreCardTableViewController: ExploreCardViewModelDelegate {
    
    func didLoadCards() {
        tableView.reloadData()
    }
    
    func didFailLoadingCards(error: Error) {
        print("Failed to load explore data: \(error)")
        showErrorAlert()
    }
}
