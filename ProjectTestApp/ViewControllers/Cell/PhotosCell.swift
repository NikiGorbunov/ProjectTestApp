//
//  PhotosCell.swift
//  ProjectTestApp
//
//  Created by Никита Горбунов on 20.10.2022.
//

import UIKit
import SDWebImage


class PhotoCell: UICollectionViewCell {
    
    static let reuseId = "PhotoCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let Label = UILabel()
        Label.translatesAutoresizingMaskIntoConstraints = false
        Label.font = UIFont.boldSystemFont(ofSize: 20)
        Label.textColor = .white
        Label.numberOfLines = 1
        return Label
    }()
    
    private let dataLabel: UILabel = {
        let Label = UILabel()
        Label.translatesAutoresizingMaskIntoConstraints = false
        Label.font = UIFont.boldSystemFont(ofSize: 20)
        Label.textColor = .white
        Label.textAlignment = .right
        return Label
    }()
    
    private let tagsLabel: UILabel = {
        let Label = UILabel()
        Label.translatesAutoresizingMaskIntoConstraints = false
        Label.font = UIFont.boldSystemFont(ofSize: 15)
        Label.textColor = .white
        Label.numberOfLines = 0
        return Label
    }()
    
    
    var flickrPhoto: Photo! {
        didSet {
            let photoUrl = flickrPhoto.url
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            photoImageView.sd_setImage(with: url)
            
            nameLabel.text = flickrPhoto.title
            tagsLabel.text = "Tag:\n\(flickrPhoto.tags ?? "")"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dataDate = dateFormatter.date(from: flickrPhoto.date)
            dataLabel.text = dateFormatter.string(from: dataDate ?? Date())
            
            
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
    }
    
    
    // MARK: - Private methods
    
    private func setupImageView() {
        addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        addSubview(dataLabel)
        dataLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        dataLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        dataLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 5).isActive = true

        
        addSubview(tagsLabel)
        tagsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        tagsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        tagsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
