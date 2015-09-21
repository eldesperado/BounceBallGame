import Foundation

class MainScene: CCNode {
    weak var playButton: CCButton?
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        SoundHelper.sharedInstace.preloadSoundTracks()
    }
    
    override func onEnter() {
        super.onEnter()
        self.togglePlayButton(true)
        SoundHelper.sharedInstace.playBGTrack(SoundTrack.Background)
    }
    
    func play(){
        self.togglePlayButton(false)
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        let transition = CCTransition(crossFadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(gameplayScene, withTransition: transition)
    }
    
    
    // MARK: Helpers
    private func togglePlayButton(isEnable: Bool) {
        if let button = self.playButton {
            button.enabled = isEnable
        }
    }
}
