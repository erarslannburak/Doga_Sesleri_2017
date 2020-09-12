//
//  ViewController.swift
//  Doga Sesleri
//
//  Created by Macbook Pro on 1.02.2017.
//  Copyright © 2017 Burak ERARSLAN. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
        
    @IBOutlet weak var collectionView:UICollectionView!
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private let itemList:[Item] = [Item(image: "evening_Crickets", sound: "eveningcrickets"),Item(image: "MountainLake", sound: "MountainLake"),Item(image: "fire", sound: "fire"),Item(image: "mysticFountain", sound: "mysticfountain"),Item(image: "plainsOfWheat", sound: "plainsofwheat"),Item(image: "rainOnLeaves", sound: "rainonleaves"),Item(image: "summerMeadow", sound: "summerMeadow"),Item(image: "sunSeatBeach", sound: "sunseatbeach"),Item(image: "thunderStorm", sound: "thunderStorm")]
    
    private var player=AVAudioPlayer()
    private var currentIndex: Int = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "MyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "myCell")
        collectionView.collectionViewLayout = flowLayout
        collectionView.delegate = self
        collectionView.dataSource = self
        playSound(currentIndex)
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func playSound(_ index:Int) {
        guard let url = Bundle.main.url(forResource: itemList[index].sound, withExtension: "mp4") else {return}
        do {
            try player = AVAudioPlayer(contentsOf: url)
            player.volume = 50
            player.play()
        }catch let error {
            print(error)
        }
    }
}


extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? MyCollectionViewCell else {return UICollectionViewCell()}
        cell.imageView.image = UIImage(named: itemList[indexPath.row].image)
        return cell
    }
}
extension ViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }

        let pageWidth = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
        currentIndex = Int(scrollView.contentOffset.x / pageWidth)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == collectionView else { return }

        let pageWidth = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
        var targetIndex = Int(roundf(Float(targetContentOffset.pointee.x / pageWidth)))
        if targetIndex > currentIndex {
            targetIndex = currentIndex + 1
        } else if targetIndex < currentIndex {
            targetIndex = currentIndex - 1
        }
        let count = collectionView.numberOfItems(inSection: 0)
        targetIndex = max(min(targetIndex, count - 1), 0)

        targetContentOffset.pointee = scrollView.contentOffset
        var offsetX: CGFloat = 0.0
        if targetIndex < count - 1 {
            offsetX = pageWidth * CGFloat(targetIndex)
        } else {
            offsetX = scrollView.contentSize.width - scrollView.frame.width
        }
        if targetIndex != self.currentIndex {
            playSound(targetIndex)
        }
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0.0), animated: true)
    }
}
