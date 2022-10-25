//
//  ViewController.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/25.
//

import UIKit
import RxCocoa
import RxSwift

class ImageListViewController: UIViewController {
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>!
    
    let viewModel = ImageListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindData()
    }
    
    func configureUI() {
        imageCollectionView.collectionViewLayout = createLayout()
        configureDataSource()
        imageCollectionView.delegate = self
        searchbar.delegate = self
    }
    
    func bindData() {
        viewModel.photoList
            .withUnretained(self)
            .bind { (vc, photo) in
                var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
                snapshot.appendSections([0])
                snapshot.appendItems(photo.results)
                vc.dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)
    }
}

extension ImageListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.requestSearchPhoto(query: searchbar.text!)
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
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SearchResult> { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = "\(itemIdentifier.likes)"
            
            DispatchQueue.global().async {
                let url = URL(string: itemIdentifier.urls.thumb)!
                let data = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    content.image = UIImage(data: data!)
                    cell.contentConfiguration = content
                }
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: imageCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
}

