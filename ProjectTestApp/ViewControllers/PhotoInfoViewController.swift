//
//  PhotoInfoViewController.swift
//  ProjectTestApp
//
//  Created by Никита Горбунов on 20.10.2022.
//

import UIKit
import SDWebImage

class PhotoInfoViewController: UIViewController {
    
    var photo: Photo?
    
    var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        
        return imageView
    }()

    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupImageView()
    }
    
    private func configure() {
        let photoUrl = photo?.url
        guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
        imageView.sd_setImage(with: url)
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

