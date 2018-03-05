//
//  MainViewController.swift
//  NoisliApp
//
//  Created by a1pamys on 2/28/18.
//  Copyright © 2018 Алпамыс. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UICollectionViewController, SliderValueSendable, RandomGenerator {
    
    var prepareToPlay = [true, true, true, true , true]
    let cellId = "cellId"
    let headerId = "headerId"
    var sliderValue: Float = 0
    let cells: [SoundCell] = []
    var audioPlayer: [AVAudioPlayer] = [AVAudioPlayer(), AVAudioPlayer(), AVAudioPlayer(), AVAudioPlayer(), AVAudioPlayer()]
    var sounds = ["rain", "fire", "storm", "moon", "sea"]
    var color = UIColor()
    var timer = Timer()
    //
    
    
    func timerF(){
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(getRandomColor), userInfo: nil, repeats: true)
    }
    
    @objc func getRandomColor(){
        let red   = CGFloat((arc4random() % 256)) / 255.0
        let green = CGFloat((arc4random() % 256)) / 255.0
        let blue  = CGFloat((arc4random() % 256)) / 255.0
        let alpha = CGFloat(1.0)
        color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        UIView.animate(withDuration: 4, delay: 0.0, options:[.repeat, .autoreverse, .allowUserInteraction], animations: {
            self.view.backgroundColor = self.color
            
        }, completion:nil)
    }
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.yellow
        getRandomColor()
        timerF()
        
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        collectionView?.register(SoundCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // %2 == 0
        return 5
    }
    
    func sendSliderValue(value: Float, index: Int) {
        sliderValue = value
        audioPlayer[index].setVolume(value, fadeDuration: 1)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SoundCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SoundCell
        cell.delegate = self
        cell.cellIndex = indexPath.row
        cell.sliderValue = sliderValue
        addToPlaylist(sound: sounds[indexPath.row], index: indexPath.row)
        if(!prepareToPlay[indexPath.row]) {
            cell.volumeSlider.isHidden = false
            cell.thumbnailImageView.image = UIImage(named: "\(sounds[indexPath.row])"+"-"+"w")
            cell.thumbnailImageView.alpha = 0.9
            audioPlayer[indexPath.row].play()
        } else {
            cell.volumeSlider.isHidden = true
            cell.thumbnailImageView.image = UIImage(named: "\(sounds[indexPath.row])"+"-"+"b")
            cell.thumbnailImageView.alpha = 0.4
            audioPlayer[indexPath.row].stop()
        }
        return cell
    }
    
    func sendRandomResult(result: [Bool]) {
        prepareToPlay = result
        collectionView?.reloadData()
    }
    
    
    func addToPlaylist(sound: String, index: Int) {
        do {
            audioPlayer[index] = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: sound, ofType: "mp3")!))
            audioPlayer[index].prepareToPlay()
        } catch {
            print(error)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //        let height =
        return CGSize(width: view.frame.width, height: 88)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: HeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderView
        header.backgroundColor = UIColor.clear
        header.delegate = self
        return header
    }
}


extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let side = (view.frame.width)/2.0
        return CGSize(width: side, height: side)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        prepareToPlay[indexPath.row] = !prepareToPlay[indexPath.row]
        collectionView.reloadItems(at: [indexPath])
    }
}


