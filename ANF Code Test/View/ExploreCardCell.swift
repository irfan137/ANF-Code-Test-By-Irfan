//
//  ExploreCardCell.swift
//  ANF Code Test
//
//  Created by Irfan Mohammed on 10/25/25.
//


import UIKit

class ExploreCardCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    let backgroundImageView = UIImageView()
    let topDescriptionLabel = UILabel()
    let titleLabel = UILabel()
    let promoMessageLabel = UILabel()
    let bottomDescriptionLabel = UILabel()
    let contentButtonsStackView = UIStackView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Private Properties
    
    var backgroundImageHeightConstraint: NSLayoutConstraint?
    private var currentCardId: String?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Clear all content
        backgroundImageView.image = nil
        currentCardId = nil
        
        // Clear labels
        topDescriptionLabel.text = nil
        topDescriptionLabel.isHidden = true
        titleLabel.text = nil
        promoMessageLabel.text = nil
        promoMessageLabel.isHidden = true
        bottomDescriptionLabel.text = nil
        bottomDescriptionLabel.isHidden = true
        
        // Remove all buttons
        contentButtonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Reset height constraint
        backgroundImageHeightConstraint?.isActive = false
        backgroundImageHeightConstraint = nil
        
        // Show loading indicator
        loadingIndicator.startAnimating()
    }
    
    private func setupUI() {
        // Configure cell
        selectionStyle = .none
        backgroundColor = .clear
        
        // Configure background image
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.clipsToBounds = true
        backgroundImageView.backgroundColor = .systemGray6
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        backgroundImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        // Configure loading indicator
        loadingIndicator.color = .systemBlue
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure top description (Font Size: 13)
        topDescriptionLabel.font = UIFont.systemFont(ofSize: 13)
        topDescriptionLabel.textColor = .secondaryLabel
        topDescriptionLabel.numberOfLines = 0
        topDescriptionLabel.isHidden = true
        topDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure title (Font Size: 17 BOLD)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure promo message (Font Size: 11)
        promoMessageLabel.font = UIFont.systemFont(ofSize: 11)
        promoMessageLabel.textColor = .systemRed
        promoMessageLabel.numberOfLines = 0
        promoMessageLabel.isHidden = true
        promoMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure bottom description (Font Size: 13)
        bottomDescriptionLabel.font = UIFont.systemFont(ofSize: 13)
        bottomDescriptionLabel.textColor = .secondaryLabel
        bottomDescriptionLabel.numberOfLines = 0
        bottomDescriptionLabel.isHidden = true
        bottomDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure content buttons stack view
        contentButtonsStackView.axis = .horizontal
        contentButtonsStackView.spacing = 12
        contentButtonsStackView.distribution = .fillEqually
        contentButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(loadingIndicator)
        contentView.addSubview(topDescriptionLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(promoMessageLabel)
        contentView.addSubview(bottomDescriptionLabel)
        contentView.addSubview(contentButtonsStackView)
        
        // Setup constraints
        let imageHeightConstraint = backgroundImageView.heightAnchor.constraint(equalToConstant: 200)
        imageHeightConstraint.priority = UILayoutPriority.defaultLow
        
        NSLayoutConstraint.activate([
            // Background image - full width with intrinsic height
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageHeightConstraint,
            
            // Loading indicator - centered in image view
            loadingIndicator.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor),
            
            // Top description
            topDescriptionLabel.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 12),
            topDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            topDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: topDescriptionLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Promo message
            promoMessageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            promoMessageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            promoMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Bottom description
            bottomDescriptionLabel.topAnchor.constraint(equalTo: promoMessageLabel.bottomAnchor, constant: 8),
            bottomDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bottomDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Content buttons
            contentButtonsStackView.topAnchor.constraint(equalTo: bottomDescriptionLabel.bottomAnchor, constant: 12),
            contentButtonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentButtonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentButtonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with card: ExploreCard, image: UIImage?) {
        // Store card ID to track which card this cell is displaying
        currentCardId = card.backgroundImage
        
        // Only configure labels and buttons if image is nil (first time)
        if image == nil {
            // Configure top description
            if let topDesc = card.topDescription {
                topDescriptionLabel.text = topDesc
                topDescriptionLabel.isHidden = false
            } else {
                topDescriptionLabel.isHidden = true
            }
            
            // Configure title
            titleLabel.text = card.title
            
            // Configure promo message
            if let promo = card.promoMessage {
                promoMessageLabel.text = promo
                promoMessageLabel.isHidden = false
            } else {
                promoMessageLabel.isHidden = true
            }
            
            // Configure bottom description (strip HTML tags)
            if let bottomDesc = card.bottomDescription {
                let cleanText = bottomDesc.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                bottomDescriptionLabel.text = cleanText
                bottomDescriptionLabel.isHidden = false
            } else {
                bottomDescriptionLabel.isHidden = true
            }
            
            // Configure content buttons
            contentButtonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            if let content = card.content, !content.isEmpty {
                for item in content {
                    let button = UIButton(type: .system)
                    button.setTitle(item.title, for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                    button.backgroundColor = .systemBlue
                    button.setTitleColor(.white, for: .normal)
                    button.layer.cornerRadius = 8
                    button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                    
                    // Store the target URL
                    button.setTitle(item.target, for: .disabled)
                    button.isEnabled = true
                    
                    contentButtonsStackView.addArrangedSubview(button)
                }
            }
            
            // Show loading indicator while image is loading
            loadingIndicator.startAnimating()
        }
        
        // Configure background image (always update this)
        if let image = image {
            backgroundImageView.image = image
            
            // Hide loading indicator when image loads
            loadingIndicator.stopAnimating()
            
            // Update height constraint based on image aspect ratio
            let aspectRatio = image.size.height / image.size.width
            let imageWidth = UIScreen.main.bounds.width - 32
            let calculatedHeight = imageWidth * aspectRatio
            
            // Deactivate old constraint
            backgroundImageHeightConstraint?.isActive = false
            
            // Create new constraint with proper aspect ratio
            backgroundImageHeightConstraint = backgroundImageView.heightAnchor.constraint(equalToConstant: max(calculatedHeight, 200))
            backgroundImageHeightConstraint?.isActive = true
        }
    }
    
    // Check if this cell is still displaying the given card
    func isDisplaying(card: ExploreCard) -> Bool {
        return currentCardId == card.backgroundImage
    }
    
    // MARK: - Actions
    
    @objc private func buttonTapped(_ sender: UIButton) {
        if let urlString = sender.title(for: .disabled),
           let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

