//
//  ViewController.swift
//  Morty
//
//  Created by Burak Çiçek on 22.03.2022.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    let allCharactersQuery = AllCharactersQuery()
    let filterQuery = FilterCharactersQuery()
    
    var characters: [AllCharactersQuery.Data.Character.Result] = []
    var filteredChars: [FilterCharactersQuery.Data.Character.Result] = []
    
    var currentPageFilter = 1
    var currentPage = 1
    var totalPage: Int = 1
    var indexPaths: [Int] = []
    var isMortySelected: Bool = false
    var isRickSelected: Bool = false
    var filterName: String!
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.identifier)
        collectionView.register(LoadingCell.self, forCellWithReuseIdentifier: LoadingCell.identifier)
        return collectionView
    }()
    
    let filterBackground = UIView()
    let filterView = UIView()
    
    let filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter"
        label.numberOfLines = 1
        label.sizeToFit()
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    let rickButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitle("Rick", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        return button
    }()
    
    
    let mortyButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitle("Morty", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Rick and Morty"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .done, target: self, action: #selector(didTapFilter))

        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        view.addSubview(filterBackground)
        view.addSubview(filterView)
        filterBackground.backgroundColor = UIColor(white: 0, alpha: 0.5)
        filterBackground.isHidden = true
        filterView.isHidden = true
        filterView.backgroundColor = .white
        filterView.addSubview(filterLabel)
        filterView.addSubview(rickButton)
        filterView.addSubview(mortyButton)
        
        mortyButton.addTarget(self, action: #selector(didTapMorty), for: .touchUpInside)
        rickButton.addTarget(self, action: #selector(didTapRick), for: .touchUpInside)
        
        loadCharactersData(page: currentPage)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        filterBackground.frame = view.frame
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(view.frame.width)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        filterView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(view.frame.width * 0.7)
            make.height.equalTo(view.frame.height * 0.2)
        }
        
        filterLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(filterView.snp_rightMargin)
        }
        
        rickButton.snp.makeConstraints { make in
            make.top.equalTo(filterLabel.snp_bottomMargin).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(filterView.snp_rightMargin)
            make.height.equalTo(50)
        }
        
        mortyButton.snp.makeConstraints { make in
            make.top.equalTo(rickButton.snp_bottomMargin).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(filterView.snp_rightMargin)
            make.height.equalTo(50)
        }
    }
    
    @objc func didTapMorty(_ sender: UIButton) {
        isMortySelected.toggle()
        if isRickSelected {
            isRickSelected.toggle()
            rickButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        setButtonImage(view: sender, on: UIImage(systemName: "circle.circle.fill")!, off: UIImage(systemName: "circle")!, onOffStatus: isMortySelected)
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        filterName = "morty"
        filteredChars = []
        filterCharacters(page: currentPage, name: filterName)
        self.collectionView.reloadData()
        currentPage = 1
        filterBackground.isHidden = true
        filterView.isHidden = true
    }
    
    @objc func didTapRick(_ sender: UIButton) {
        isRickSelected.toggle()
        if isMortySelected {
            isMortySelected.toggle()
            mortyButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        setButtonImage(view: sender, on: UIImage(systemName: "circle.circle.fill")!, off: UIImage(systemName: "circle")!, onOffStatus: isRickSelected)
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        filteredChars = []
        filterName = "rick"
        filterCharacters(page: currentPage, name: filterName)
        self.collectionView.reloadData()
        currentPage = 1
        filterBackground.isHidden = true
        filterView.isHidden = true
    }
    
    func setButtonImage(view: UIButton, on: UIImage, off: UIImage, onOffStatus: Bool) {
        switch onOffStatus {
             case true:
                view.setImage(on, for: .normal)
                
             default:
                view.setImage(off, for: .normal)
        }
    }
    
    @objc func didTapFilter() {
        
        filterBackground.isHidden = false
        filterView.isHidden = false
        
        filterBackground.isUserInteractionEnabled = true
        filterBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped)))
        
    }
    
    @objc func backgroundTapped() {
        filterBackground.isHidden = true
        filterView.isHidden = true
    }

    private func loadCharactersData(page: Int) {
        Network.shared.apollo.fetch(query: AllCharactersQuery(page: page)) { [weak self] result in
          switch result {
          case .success(let graphQLResult):
              
              if let characters = graphQLResult.data?.characters?.results?.compactMap({ $0 }) {
                  self?.characters.append(contentsOf: characters)
                  self?.totalPage = graphQLResult.data?.characters?.info?.pages ?? 1
                  self?.currentPage = (graphQLResult.data?.characters?.info?.next ?? 1) - 1
                  DispatchQueue.main.async {
                      self?.collectionView.reloadData()
                  }
                  
                  //print("Current Page: \(self?.currentPage)")
              }
          case .failure(let error):
            print("Error loading data \(error)")
          }
        }
    }
    
    private func filterCharacters(page: Int, name: String) {
        Network.shared.apollo.fetch(query: FilterCharactersQuery(name: name, page: page)) { [weak self] result in
            
            switch result {
            case .success(let graphQLResult):
                
                if let characters = graphQLResult.data?.characters?.results?.compactMap({ $0 }) {
                    self?.filteredChars.append(contentsOf: characters)
                    self?.totalPage = graphQLResult.data?.characters?.info?.pages ?? 1
                    self?.currentPageFilter = (graphQLResult.data?.characters?.info?.next ?? 1) - 1
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                    //print("Current Page: \(self?.currentPageFilter)")
                }
            case .failure(let error):
              print("Error loading data \(error)")
            }
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isRickSelected || isMortySelected {
            return filteredChars.count
        }
        
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if currentPage < totalPage && indexPath.row == characters.count - 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.identifier, for: indexPath) as? LoadingCell else {
                fatalError()
            }
            
            cell.spinner.startAnimating()
            
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell.identifier, for: indexPath) as? MainCell else {
                fatalError()
            }
            
            if isRickSelected || isMortySelected {
                let character = filteredChars[indexPath.item]
                cell.configure(with: character)
                return cell
            }
            
            let character = characters[indexPath.item]
            cell.configure(with: character)
            
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 60
        
        if currentPage < totalPage && indexPath.row == characters.count - 1 {
            return CGSize(width: width, height: width * 0.2)
        }
        
        return CGSize(width: width, height: width * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentPage < totalPage && indexPath.row == characters.count - 1 {
            currentPage += 1
            loadCharactersData(page: currentPage)
        }
        
        if isRickSelected || isMortySelected {
            if currentPageFilter < totalPage && indexPath.row == filteredChars.count - 1 {
                currentPageFilter += 1
                filterCharacters(page: currentPage, name: filterName)
            }
        }
    }
}
