//
//  MenuViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 6/3/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UIKit
import KRLCollectionViewGridLayout

private let reuseIdentifier = "MenuCell"
private let sectionInset: CGFloat = 25
private let itemSpacing: CGFloat = 15

class MenuItem {
    let title: String
    let image: String // image name (square)
    let storyboardID: String? // storyboard ID for view controller to push when tapped (or nil)
    
    init(title: String, image: String, storyboardID: String?) {
        self.title = title
        self.image = image
        self.storyboardID = storyboardID
    }
}

class MenuViewController: UICollectionViewController {
    
    private let items = [MenuItem(title: "Schedule", image: "schedule", storyboardID: ScheduleViewController.storyboardID),
                         MenuItem(title: "DJs", image: "djs", storyboardID: DJListViewController.storyboardID),
                         MenuItem(title: "About", image: "about", storyboardID: AboutViewController.storyboardID)]
    
    var layout: KRLCollectionViewGridLayout {
        return self.collectionView?.collectionViewLayout as! KRLCollectionViewGridLayout
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
        collectionView!.registerClass(MenuCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout.numberOfItemsPerLine = 2
        layout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        layout.interitemSpacing = itemSpacing
        layout.lineSpacing = itemSpacing
        
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.alwaysBounceVertical = true
        
        view.backgroundColor = Constants.Colors.lightBlue
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(false, animated: true)
        }
    }
    
    // MARK: - Actions
    
    func pushViewController(storyboardID: String) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardID)
        if let navigationController = navigationController {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        cell.contentView.backgroundColor = Constants.Colors.gold
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let item = items[indexPath.row]
        if let menuCell = cell as? MenuCollectionViewCell {
            menuCell.styleForMenuItem(item)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        let item = items[indexPath.row]
        if let storyboardID = item.storyboardID {
            pushViewController(storyboardID)
        }
        
    }
    
}
