//
//  MainViewController.swift
//  NoisliApp
//
//  Created by a1pamys on 2/28/18.
//  Copyright © 2018 Алпамыс. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UICollectionViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
//    var sliderValue: Float = 0
    var timer = Timer()
    var sounds: [Sound]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        sounds = Sound.getSounds()
        getRandomColor()
        timerF()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.register(SoundCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    func timerF(){
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(getRandomColor), userInfo: nil, repeats: true)
    }
    
    @objc func getRandomColor(){
        let red   = CGFloat((arc4random() % 256)) / 255.0
        let green = CGFloat((arc4random() % 256)) / 255.0
        let blue  = CGFloat((arc4random() % 256)) / 255.0
        UIView.animate(withDuration: 4, delay: 0.0, options:[.repeat, .autoreverse, .allowUserInteraction], animations: {
            self.view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }, completion:nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (sounds?.count)!
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: HeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderView
        header.backgroundColor = UIColor.clear
        header.delegate = self
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SoundCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SoundCell
        let sound = sounds![indexPath.row]
        cell.delegate = self
        cell.cellIndex = indexPath.row
        cell.sliderValue = sound.volume
        print("Slider[\(indexPath.row)]: \(cell.sliderValue)")
        if(!sounds![indexPath.row].prepareToPlay!) {
            cell.volumeSlider.isHidden = false
            cell.thumbnailImageView.image = UIImage(named: "\(sound.soundName!)"+"-"+"w")
            cell.thumbnailImageView.alpha = 0.9
            print("Play: \(indexPath.row)")
            sounds![indexPath.row].audioPlayer!.play()
//            print(sounds![indexPath.row].audioPlayer!.currentTime)
        } else {
            cell.volumeSlider.isHidden = true
            cell.thumbnailImageView.image = UIImage(named: "\(sound.soundName!)"+"-"+"b")
            cell.thumbnailImageView.alpha = 0.4
            sounds![indexPath.row].audioPlayer!.stop()
//            print(sounds![indexPath.row].audioPlayer!.currentTime)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sounds![indexPath.row].prepareToPlay! = !sounds![indexPath.row].prepareToPlay!
//        print(indexPath.row)
        print("reloadItemAtIndexPath: \(indexPath.row)")
        collectionView.reloadItems(at: [indexPath])
    }
}


extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let side = (view.frame.width)/2.0
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MainViewController: SliderValueSendable {
    func sendSliderValue(value: Float, index: Int) {
//        sliderValue = value
        sounds![index].volume = value
    }
}

extension MainViewController: RandomGenerator {
    func sendRandomResult(result: [Float]) {
        var i = 0
        print(result)
        while (i < (sounds?.count)!) {
            if (result[i] > 0.0) {
                sounds![i].prepareToPlay! = false
                sounds![i].volume = result[i]
            } else {
                sounds![i].prepareToPlay! = true
            }
            i += 1
        }
        collectionView?.reloadData()
    }
}

