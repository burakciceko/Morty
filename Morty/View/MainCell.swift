//
//  MainCell.swift
//  Morty
//
//  Created by Burak Çiçek on 23.03.2022.
//

import UIKit
import SnapKit

class MainCell: UICollectionViewCell {
    
    static let identifier = "MainCell"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 15
        //self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true

        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        
        contentView.addSubview(profileImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(idLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(contentView.frame.height * 0.6)
            
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp_bottomMargin).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp_bottomMargin).offset(10)
            make.left.equalToSuperview().offset(10)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottomMargin).offset(10)
            make.left.equalToSuperview().offset(10)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        idLabel.text = nil
        nameLabel.text = nil
        locationLabel.text = nil
    }
    
    func configure(with character: AllCharactersQuery.Data.Character.Result) {
        if let imageUrl = character.image {
            let url = URL(string: imageUrl)
            let data = try? Data(contentsOf: url!)
            profileImage.image = UIImage(data: data!)
        }
        
        if let id = character.id?.count {
            idLabel.text = ("#id: \(id)")
        }
        
        if let name = character.name {
            let text = NSMutableAttributedString()
            text.append(NSAttributedString(string: "Name: ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
            text.append(NSAttributedString(string: name, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]))
            nameLabel.attributedText = text
        }
        
        if let location = character.location?.name {
            let text = NSMutableAttributedString()
            text.append(NSAttributedString(string: "Location: ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
            text.append(NSAttributedString(string: location, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]))
            locationLabel.attributedText = text
        }
    }
    
    func configure(with character: FilterCharactersQuery.Data.Character.Result) {
        if let imageUrl = character.image {
            let url = URL(string: imageUrl)
            let data = try? Data(contentsOf: url!)
            profileImage.image = UIImage(data: data!)
        }
        
        if let id = character.id?.count {
            idLabel.text = ("#id: \(id)")
        }
        
        if let name = character.name {
            let text = NSMutableAttributedString()
            text.append(NSAttributedString(string: "Name: ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
            text.append(NSAttributedString(string: name, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]))
            nameLabel.attributedText = text
        }
        
        if let location = character.location?.name {
            let text = NSMutableAttributedString()
            text.append(NSAttributedString(string: "Location: ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
            text.append(NSAttributedString(string: location, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]))
            locationLabel.attributedText = text
        }
    }
    
}
