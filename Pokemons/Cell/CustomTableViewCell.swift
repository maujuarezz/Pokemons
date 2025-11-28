//
//  CustomTableViewCell.swift
//  HttpRequest
//
//  Created by Mauro Juárez Zavaleta on 27/11/25.
//
import UIKit

class CustomTableViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.elevate()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let containerMargin = CGFloat(8)
    let containerTopBottomMargin: CGFloat = 4

    func setupUI() {
        //agrega a la vista
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        
        //constaint para el container
        containerView.topAnchor.constraint(equalTo:
            contentView.topAnchor, constant: containerTopBottomMargin).isActive = true
        containerView.bottomAnchor.constraint(equalTo:
            contentView.bottomAnchor, constant: -containerTopBottomMargin).isActive = true
        containerView.leadingAnchor.constraint(equalTo:
            contentView.leadingAnchor, constant: containerMargin).isActive = true
        containerView.trailingAnchor.constraint(equalTo:
            contentView.trailingAnchor, constant: -containerMargin).isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo:
                containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo:
                containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo:
                containerView.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo:
                titleLabel.bottomAnchor,constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo:
                containerView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo:
                containerView.trailingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(equalTo:
                containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func setupCell(title: String, subtitle: String) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
    }
}
