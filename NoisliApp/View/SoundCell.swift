////
////  SoundCell.swift
////  NoisliApp
////
////  Created by a1pamys on 2/28/18.
////  Copyright © 2018 Алпамыс. All rights reserved.

import UIKit
import AVFoundation

protocol SliderValueSendable {
    func sendSliderValue(value: Float, index: Int)
}

class SoundCell: UICollectionViewCell {
 
    var delegate: SliderValueSendable?
    var cellIndex = -1
    var sliderValue: Float = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        backgroundColor = UIColor.clear
        setupViews()
    }
    
    
    
    lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = UIColor.white
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderDidUsed), for: .valueChanged)
        slider.value = sliderValue
        slider.minimumTrackTintColor = UIColor.white
//        slider.maximumTrackTintColor = UIColor.lightGray
//        slider.setThumbImage(UIImage(named: "circle"), for: .normal)
//        slider.contentMode = .scaleAspectFill
        return slider
    }()
    
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        //        imageView.backgroundColor = UIColor.orange
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "rain-w")
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()
    
    @objc func sliderDidUsed() {
        print("sliderDidUsed")
        print(sliderValue)
//        sliderValue = volumeSlider.value
        delegate?.sendSliderValue(value: volumeSlider.value, index: cellIndex)
    }
    
    func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(volumeSlider)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-48-[v0]-48-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : thumbnailImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[v0]-32-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : volumeSlider]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-32-[v0]-64-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : thumbnailImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-8-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : thumbnailImageView, "v1" : volumeSlider]))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

