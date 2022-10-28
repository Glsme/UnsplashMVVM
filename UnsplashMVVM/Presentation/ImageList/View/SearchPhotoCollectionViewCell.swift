//
//  SearchPhotoCollectionViewCell.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/27.
//

import UIKit
import SnapKit

class SearchPhotoCollectionViewCell: UICollectionViewCell {
    
    let searchedImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let likeLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    let createdDateLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    let updatedDateLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI() {
        [searchedImageView, likeLabel, createdDateLabel, updatedDateLabel].forEach {
            self.addSubview($0)
        }
    }
    
    func setConstraints() {
        searchedImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.width.height.equalTo(self.snp.height).multipliedBy(0.8)
            make.leading.equalTo(self.snp.leading).offset(20)
        }

        updatedDateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(searchedImageView.snp.bottom)
            make.leading.equalTo(searchedImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self.snp.trailing).offset(-10)
            make.height.equalTo(20)
        }

        createdDateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(updatedDateLabel.snp.top)
            make.leading.equalTo(searchedImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self.snp.trailing).offset(-10)
            make.height.equalTo(20)
        }

        likeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(createdDateLabel.snp.top)
            make.leading.equalTo(searchedImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self.snp.trailing).offset(-10)
            make.height.equalTo(20)
        }
    }
    
}
