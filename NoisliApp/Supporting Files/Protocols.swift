//
//  Protocols.swift
//  NoisliApp
//
//  Created by a1pamys on 3/5/18.
//  Copyright © 2018 Алпамыс. All rights reserved.
//

protocol RandomGenerator {
    func sendRandomResult(result: [Float])
}

protocol SliderValueSendable {
    func sendSliderValue(value: Float, index: Int)
}
