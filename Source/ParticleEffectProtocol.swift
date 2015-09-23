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
    func createDisappearParticle() -> CCParticleSystem?
}

extension ParticleEffectProtocol  {
    func createExplosionParticle() -> CCParticleSystem? {
        let explosion = ParticleHelper.createParticle("Explosion")
        return explosion
    }
    
    func createDisappearParticle() -> CCParticleSystem? {
        let particle = ParticleHelper.createParticle("Disappear")
        return particle
    }
}

struct ParticleHelper {
    static func createParticle(particleName: String, autoRemoveOnFinish: Bool = true) -> CCParticleSystem? {
        let filePath = "Effects/" + particleName
        if let particle = CCBReader.load(filePath) as? CCParticleSystem {
            particle.autoRemoveOnFinish = autoRemoveOnFinish
            return particle
        }
        return nil
    }
    
    static func getParticleLongestLife(particle: CCParticleSystem) -> Float {
        return particle.life + particle.lifeVar
    }
}