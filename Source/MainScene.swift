import Foundation

class MainScene: CCNode {
    weak var playButton: CCButton?
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
    }
    
    override func onEnter() {
        super.onEnter()
        self.togglePlayButton(true)
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
