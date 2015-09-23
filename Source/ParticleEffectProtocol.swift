//
//  ParticleEffectProtocol.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/23/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import Foundation

protocol ParticleEffectProtocol {
    func createExplosionParticle() -> CCParticleSystem?
}

extension ParticleEffectProtocol  {
    func createExplosionParticle() -> CCParticleSystem? {
        guard let explosion = CCBReader.load("Effects/Explosion") as? CCParticleSystem else  { return nil }
        explosion.autoRemoveOnFinish = true
        return explosion
    }
}
