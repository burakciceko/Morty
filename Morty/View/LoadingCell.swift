//
//  LoadingCell.swift
//  Morty
//
//  Created by Burak Çiçek on 24.03.2022.
//

import UIKit
import SnapKit

class LoadingCell: UICollectionViewCell {
    static let identifier = "LoadingCell"
    
    let spinner = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(spinner)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        spinner.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
}
