import UIKit
import SnapKit

class SteppedSliderView: UIView {
    
    let selectedBackground = UIView()
    let unselectedBackground = UIView()
    let thumb = UIImageView()
    
    // Helper variables
    private let steps: Int
    private var currentStep: Int
    private var rangeSpace: CGFloat = 0
    private var gradientLayer = CAGradientLayer() {
        didSet {
            self.gradientLayer.cornerRadius = self.unselectedBackground.layer.cornerRadius
        }
    }
    
    
    init(steps: Int) {
        self.steps = steps
        self.currentStep = steps / 2
        super.init(frame: .zero)
        self.buildViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gradient(frame: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        let c1 = UIColor(red: 255 / 255, green: 0 / 255, blue: 38 / 255, alpha: 1).cgColor
        let c2 = UIColor(red: 255 / 255, green: 138 / 255, blue: 14 / 255, alpha: 1).cgColor
        let c3 = UIColor(red: 255 / 255, green: 219 / 255, blue: 0 / 255, alpha: 1).cgColor
        let c4 = UIColor(red: 92 / 255, green: 255 / 255, blue: 0 / 255, alpha: 1).cgColor
        layer.colors = [c1, c2, c3, c4]
        return layer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maximumWidth = self.getMaximumWidth()
        self.rangeSpace = maximumWidth / CGFloat(self.steps)
        
        self.gradientLayer = self.gradient(frame: self.selectedBackground.bounds)
        self.selectedBackground.layer.addSublayer(self.gradientLayer)
    }
    
    private func buildViews() {
        self.addSubviews()
        self.formatViews()
        self.addConstraintsToSubviews()
    }
    
    private func addSubviews() {
        self.addSubview(self.unselectedBackground)
        self.addSubview(self.selectedBackground)
        self.addSubview(self.thumb)
    }
    
    private func formatViews() {
        self.selectedBackground.layer.cornerRadius = 3
        
        self.unselectedBackground.layer.cornerRadius = 3
        self.unselectedBackground.backgroundColor = UIColor.lightGray
        
        let image = UIImage(named: "group2")
        self.thumb.image = image
        self.thumb.isUserInteractionEnabled = true
        let thumbGesture = UIPanGestureRecognizer(target: self, action: #selector(thumbDidMove(_:)))
        self.thumb.addGestureRecognizer(thumbGesture)
    }
    
    private func addConstraintsToSubviews() {
        unselectedBackground.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(2)
            make.centerY.equalTo(self)
            make.height.equalTo(5)
        }
        
        selectedBackground.snp.makeConstraints { make in
            make.left.centerY.equalTo(self.unselectedBackground)
            make.height.equalTo(6)
            let width = CGFloat(self.currentStep) * self.rangeSpace
            make.width.equalTo(width)
        }
        
        thumb.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.unselectedBackground)
        }
    }
    
    @objc func thumbDidMove(_ recognizer: UIPanGestureRecognizer) {
        guard recognizer.state == .ended else {
            return
        }
        
        let translation = recognizer.translation(in: self)
        let translationX = self.calculateX(basedOn: translation)
        let currentX = CGFloat(self.currentStep) * self.rangeSpace
        
        self.updateCurrentStepFor(incoming: translationX, andCurrent: currentX)
        self.moveThumb()
        self.setSelectedBackgroundWidth()
    }
    
    private func calculateX(basedOn translation: CGPoint) -> CGFloat {
        return translation.x > 0 ?
            self.calculateXForFurther(translation: translation):
            self.calculateXForPrevious(translation: translation)
    }
    
    private func calculateXForFurther(translation: CGPoint) -> CGFloat {
        let maximumX = self.getMaximumWidth()
        let roundedX = self.getXRounded(for: translation)
        let xAxis = roundedX > maximumX ? maximumX: roundedX
        return xAxis
    }

    private func calculateXForPrevious(translation: CGPoint) -> CGFloat {
        let minimumX = 0 + (self.thumb.frame.width / 2)
        let roundedX = self.getXRounded(for: translation)
        let xAxis = roundedX < minimumX ? minimumX: roundedX
        return xAxis
    }
    
    private func updateCurrentStepFor(incoming incomingX: CGFloat, andCurrent currentX: CGFloat) {
        if incomingX > currentX {
            self.currentStep += 1
            return
        }
        
        if incomingX < currentX {
            self.currentStep -= 1
            return
        }
    }
    
    private func moveThumb() {
        let nextX = CGFloat(self.currentStep) * self.rangeSpace
        let halfOfMaximumX = self.getMaximumWidth() / 2
        
        thumb.snp.updateConstraints { make in
            make.centerX.equalTo(self).inset(nextX - halfOfMaximumX)
        }
    }
    
    private func setSelectedBackgroundWidth() {
        let nextX = CGFloat(self.currentStep) * self.rangeSpace
        
        self.gradientLayer.removeFromSuperlayer()
        selectedBackground.snp.updateConstraints { make in
            make.width.equalTo(nextX)
        }
    }
}

// Helper variables

extension SteppedSliderView {
    func getMaximumWidth() -> CGFloat {
        return self.frame.width - (self.thumb.frame.width / 2)
    }
    
    func getXRounded(for translation: CGPoint) -> CGFloat {
        return (self.thumb.center.x + translation.x).rounded(.toNearestOrEven)
    }
}
