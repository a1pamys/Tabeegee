//
//  HeaderView.swift
//  NoisliApp
//
//  Created by a1pamys on 3/1/18.
//  Copyright © 2018 Алпамыс. All rights reserved.
//

import UIKit

class HeaderView: UICollectionViewCell {
    
    var delegate: RandomGenerator?
    
    lazy var randomButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = UIColor.clear
        button.setTitle("RANDOM", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.font = UIFont(name: "OriyaSangamMN-Bold", size: 18)
        button.addTarget(self, action: #selector(randomButtonDidPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = UIColor.clear
        button.setTitle("FAVORITE", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.font = UIFont(name: "OriyaSangamMN-Bold", size: 18)
        button.addTarget(self, action: #selector(favoriteButtonDidPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        printFonts()
        backgroundColor = UIColor.blue
        setupViews()
    }
    
    func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
    
    func setupViews() {
        addSubview(randomButton)
        addSubview(favoriteButton)
        let width = (frame.width-40)/2
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(\(width))]-8-[v1(\(width))]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : randomButton, "v1" : favoriteButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : randomButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : favoriteButton]))
    }
    
    @objc func randomButtonDidPressed() {
        var result: [Float] = []
        var f = 0
        while (f < 2 || f == 5) {
            f = 0
            result.removeAll()
            for _ in 1...5 {
                if(Int(arc4random_uniform(2)) % 2 == 0) {
                    result.append(0.0)
                    f += 1
                } else {
                    let volume = Float(drand48())
                    result.append(volume)
                }
            }
        }
        delegate?.sendRandomResult(result: result)
    }
    
    @objc func favoriteButtonDidPressed() {
        print("Favorite button was pressed")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


