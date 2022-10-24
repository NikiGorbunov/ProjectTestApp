//
//  PhotosCollectionViewController.swift
//  ProjectTestApp
//
//  Created by Никита Горбунов on 20.10.2022.
//

import UIKit

enum SortType: String {
    case title
    case date
}

class PhotosCollectionViewController: UICollectionViewController {
    
    static let reuseId = "PhotoCell"
    
    private var timer: Timer?
    private var sortType: SortType = .title
    private var networkDataFetcher = NetworkDataFetcher()
    private var photos = [Photo]()
    
    private let itemsPerRow: CGFloat = 1
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
     
    private lazy var barButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Sort: \(sortType)", style: .plain, target: self, action: #selector(sortBarButtonTapped))
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        setupSearchBar()

    }
    
//MARK: - NavigationItems action
    
    @objc private func sortBarButtonTapped(sender: UIBarButtonItem) {
        
        switch sortType {
        case .title:
            sortType = .date
        case .date:
            sortType = .title
        }
        sender.title = "sort: \(sortType)"
        sortImages()
    }
    
//MARK: - Setup UI Elements
    
    private func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseId)
        
        collectionView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.contentInsetAdjustmentBehavior = .automatic
    }
    
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "PHOTOS"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationItem.rightBarButtonItems = [barButtonItem]
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func sortImages() {
        switch sortType {
        case .title:
            self.photos.sort(by: {$0.title < $1.title})
        case .date:
            self.photos.sort(by: {$0.date > $1.date})
        }
        collectionView.reloadData()
    }
    


    
    
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath) as! PhotoCell
        let flickrPhoto = photos[indexPath.row]
        cell.flickrPhoto = flickrPhoto
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let infoVC = PhotoInfoViewController(photo: photos[indexPath.item])
        let nc = UINavigationController(rootViewController: infoVC)
        nc.modalPresentationStyle = .automatic
        self.present(nc, animated: true)
    }
 

}

// MARK: - UISearchBarDelegate

extension PhotosCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] searchResults in
                guard let fetchedPhotos = searchResults else { return }
                self?.photos = fetchedPhotos.photos.photo
                self?.collectionView.reloadData()
            }
        })
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
