import Foundation

class MainScene: CCNode {
    weak var timeLabel: CCLabelTTF!
    weak var lifeLabel: CCLabelTTF!
    weak var playButton: CCButton!
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
    }
    
    func play(){
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        let transition = CCTransition(crossFadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(gameplayScene, withTransition: transition)
    }
    
    func handleGameOver() {
        
    }
    
    func changeScene(nextSceneNode: CCNode) {
        
    }
    
    
}
