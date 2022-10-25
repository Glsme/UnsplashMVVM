//
//  ViewController.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/25.
//

import UIKit

class ImageListViewController: UIViewController {

    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    
    let viewModel = ImageListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        imageCollectionView.collectionViewLayout = createLayout()
        configureDataSource()
        imageCollectionView.delegate = self

    }
}

extension ImageListViewController: UICollectionViewDelegate {
    
}

extension ImageListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: imageCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(["😎"])
        dataSource.apply(snapshot)
    }
}

