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
        UnsplashAPIManager.shared.requestUnsplashPhotoWithAPIRouter(query: "apple", page: 1, router: APIRouter.get(query: "apple", page: 1)) { _, _ in
            
        }
    }
    
    func configureUI() {
        imageCollectionView.collectionViewLayout = createLayout()
        imageCollectionView.keyboardDismissMode = .onDrag
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
        
        imageCollectionView.rx.prefetchItems
            .compactMap { $0.last?.item }
            .withUnretained(self)
            .bind { (vc, item) in
                vc.viewModel.requestPhotoPagination(query: vc.imageSearchbar.text!, index: item)
            }
            .disposed(by: disposeBag)
        
//        imageCollectionView.rx.sele
//        zip
        
        imageCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe { (vc, indexPath) in
                let sb = UIStoryboard(name: "Main", bundle: nil)
                guard let detailVC = sb.instantiateViewController(withIdentifier: "ImageDetailViewController") as? ImageDetailViewController else { return }
                detailVC.viewModel.imageUrl.onNext(try! vc.viewModel.photoList.value().results[indexPath.item].urls.raw)
                vc.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        imageSearchbar.rx.text
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { (vc, text) in
                guard let text = text else { return }
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
                    cell.likeLabel.text = "♥️ \(itemIdentifier.likes)"
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
