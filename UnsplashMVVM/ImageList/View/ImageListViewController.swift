//
//  ImageListViewController.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/27.
//

import UIKit

import RxSwift
import RxCocoa
class ImageListViewController: UIViewController {
    
    @IBOutlet weak var ImageSearchbar: UISearchBar!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    let viewModel = ImageListViewModel()
    let disposeBag = DisposeBag()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, PhotoResults>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollectionView.collectionViewLayout = createLayout()
        configureDataSource()
        
        viewModel.requestPhoto(query: "apple")
        bindData()
    }
    
    func bindData() {
        viewModel.photoList
            .withUnretained(self)
            .bind { (vc, value) in
                var snapshot = NSDiffableDataSourceSnapshot<Int, PhotoResults>()
                snapshot.appendSections([0])
                snapshot.appendItems(value.results)
                vc.dataSource.apply(snapshot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)
    }
}

extension ImageListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchPhotoCollectionViewCell, PhotoResults> { cell, indexPath, itemIdentifier in
            
            DispatchQueue.global().async {
                let url = URL(string: itemIdentifier.urls.thumb)!
                let data = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    cell.searchedImageView.image = UIImage(data: data!)
                }
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: imageCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
}
