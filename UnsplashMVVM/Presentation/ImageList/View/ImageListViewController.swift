//
//  ImageListViewController.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/27.
//

import UIKit
import Photos

import RxSwift
import RxCocoa
class ImageListViewController: UIViewController {
    
    @IBOutlet weak var imageSearchbar: UISearchBar!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    let viewModel = ImageListViewModel()
    let disposeBag = DisposeBag()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, PhotoResults>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureDataSource()
        bindData()
    }
    
    func configureUI() {
        imageCollectionView.collectionViewLayout = createLayout()
        imageCollectionView.keyboardDismissMode = .onDrag
    }
    
    func bindData() {
        
        let input = ImageListViewModel.Input(searchText: imageSearchbar.rx.text,
                                             prefetchItems: imageCollectionView.rx.prefetchItems,
                                             itemSelected: imageCollectionView.rx.itemSelected)
        let output = viewModel.transform(input: input, disposebag: disposeBag)
        
        viewModel.photoList
            .withUnretained(self)
            .bind { (vc, value) in
                var snapshot = NSDiffableDataSourceSnapshot<Int, PhotoResults>()
                snapshot.appendSections([0])
                snapshot.appendItems(value.results)
                vc.dataSource.apply(snapshot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)
        
        output.itemSelected
            .withUnretained(self)
            .subscribe { (vc, indexPath) in
                let sb = UIStoryboard(name: "Main", bundle: nil)
                guard let detailVC = sb.instantiateViewController(withIdentifier: "ImageDetailViewController") as? ImageDetailViewController else { return }
                detailVC.viewModel.imageUrl.onNext(try! vc.viewModel.photoList.value().results[indexPath.item].urls.raw)
                vc.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.searchText
            .withUnretained(self)
            .subscribe { (vc, text) in
                vc.viewModel.searchedText = text
                vc.viewModel.requestPhoto(query: text)
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
                    cell.likeLabel.text = "?????? \(itemIdentifier.likes)"
                    cell.createdDateLabel.text = "\(itemIdentifier.createdAt)"
                    cell.updatedDateLabel.text = "\(itemIdentifier.updatedAt)"
                }
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: imageCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
}
