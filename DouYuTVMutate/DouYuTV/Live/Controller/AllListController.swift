//
//  AllListController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/16.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class AllListController: BaseViewController {
    
    struct ConstantValue {
        static let sectionHeaderHeight = CGFloat(44.0)
        static let anchorCellHeight = CGFloat(150.0)
        static let anchorCellMargin = CGFloat(10.0)
    }
    
    lazy var layout: UICollectionViewFlowLayout = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = ConstantValue.anchorCellMargin
        layout.minimumInteritemSpacing = ConstantValue.anchorCellMargin
        // 每一排显示两个cell
        layout.itemSize = CGSize(width: (self.view.bounds.width - 3*layout.minimumInteritemSpacing)/2, height: ConstantValue.anchorCellHeight)
        layout.scrollDirection = .Vertical
        // 间距
        layout.sectionInset = UIEdgeInsets(top: ConstantValue.anchorCellMargin, left: ConstantValue.anchorCellMargin, bottom: ConstantValue.anchorCellMargin, right: ConstantValue.anchorCellMargin)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.layout)
        collectionView.registerNib(UINib(nibName: String(AnchorCell), bundle: nil), forCellWithReuseIdentifier: self.anchorCell)
        collectionView.backgroundColor = UIColor.whiteColor()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    let anchorCell = "anchorCell"
    
    private let viewModel: AllListViewModel
    
    init(viewModel: AllListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    var dataModel: TagModel = TagModel()
    // 这里面获取到的view.bounds 不是最终的(ContentView里面设置之后才是准确的frame)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        viewModel.loadDataWithHandler {[weak self] (loadState) in
            guard let `self` = self else { return }

            switch loadState {
            case .success:
                self.collectionView.reloadData()
            default: break
            }
        }
        
    }
    

    
    override func addConstraints() {
        collectionView.snp_makeConstraints { (make) in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

extension AllListController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return viewModel.data.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(anchorCell, forIndexPath: indexPath) as! AnchorCell
        // 设置数据
        
        cell.configCell(viewModel.data[indexPath.row])
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let playerVc = PlayerController()
        playerVc.roomID = viewModel.data[indexPath.row].room_id
        playerVc.title = "播放"
        showViewController(playerVc, sender: nil)
    }
}



