import UIKit
import SnapKit

class SteppedFuelSliderView: UIView {
    
    // UI
    private let selectedBackground = UIView()
    private let unselectedBackground = UIView()
    private let thumb = UIImageView()
    // Dividers
    private let noFuelDivider = UIView()
    private let oneQuarterDivider = UIView()
    private let halfFuelDivider = UIView()
    private let threeQuarterDivider = UIView()
    private let fullFuelDivider = UIView()
    // Dividers Label
    private let noFuelLabel = UILabel()
    private let oneQuarterLabel = UILabel()
    private let halfFuelLabel = UILabel()
    private let threeQuarterLabel = UILabel()
    private let fullFuelLabel = UILabel()
    
    // Helper variables
    private let steps: Int = 4
    private var currentStep: Int = 2
    private var rangeSpace: CGFloat = 0
    private var gradientLayer = CAGradientLayer() {
        didSet {
            self.gradientLayer.cornerRadius = self.unselectedBackground.layer.cornerRadius
        }
    }
    
    init() {
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
        
        self.constraintDividers()
        self.constrainDividersLabel()
        self.sendDividersToBack()
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
        
        self.addSubview(self.noFuelDivider)
        self.addSubview(self.oneQuarterDivider)
        self.addSubview(self.halfFuelDivider)
        self.addSubview(self.threeQuarterDivider)
        self.addSubview(self.fullFuelDivider)
        
        self.addSubview(self.noFuelLabel)
        self.addSubview(self.oneQuarterLabel)
        self.addSubview(self.halfFuelLabel)
        self.addSubview(self.threeQuarterLabel)
        self.addSubview(self.fullFuelLabel)
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
        
        self.noFuelDivider.backgroundColor = UIColor.lightGray
        self.oneQuarterDivider.backgroundColor = UIColor.lightGray
        self.halfFuelDivider.backgroundColor = UIColor.lightGray
        self.threeQuarterDivider.backgroundColor = UIColor.lightGray
        self.fullFuelDivider.backgroundColor = UIColor.lightGray
        
        self.noFuelLabel.font = UIFont.systemFont(ofSize: 11)
        self.noFuelLabel.textColor = UIColor.lightGray
        self.noFuelLabel.numberOfLines = 2
        self.noFuelLabel.text = "Na\nReserva"
        self.oneQuarterLabel.font = UIFont.systemFont(ofSize: 11)
        self.oneQuarterLabel.textColor = UIColor.lightGray
        self.oneQuarterLabel.text = "1/4"
        self.halfFuelLabel.font = UIFont.systemFont(ofSize: 11)
        self.halfFuelLabel.textColor = UIColor.lightGray
        self.halfFuelLabel.text = "1/2"
        self.threeQuarterLabel.font = UIFont.systemFont(ofSize: 11)
        self.threeQuarterLabel.textColor = UIColor.lightGray
        self.threeQuarterLabel.text = "3/4"
        self.fullFuelLabel.textAlignment = .right
        self.fullFuelLabel.font = UIFont.systemFont(ofSize: 11)
        self.fullFuelLabel.textColor = UIColor.lightGray
        self.fullFuelLabel.numberOfLines = 2
        self.fullFuelLabel.text = "Tanque\nCheio"
    }
    
    private func addConstraintsToSubviews() {
        unselectedBackground.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.right.equalTo(self).inset(2)
            make.height.equalTo(5)
        }
        
        selectedBackground.snp.makeConstraints { make in
            make.left.centerY.equalTo(self.unselectedBackground)
            make.height.equalTo(6)
            let width = CGFloat(self.currentStep) * self.rangeSpace
            make.width.equalTo(width)
        }
        
        thumb.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.unselectedBackground)
        }
    }
    
    private func constraintDividers() {
        let fullWidth = self.unselectedBackground.frame.width
        let halfWidth = fullWidth / 2
        
        noFuelDivider.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.height.equalTo(22)
            make.centerY.equalTo(self.unselectedBackground)
            make.centerX.equalTo(self.unselectedBackground).inset(-halfWidth)
        }
        
        oneQuarterDivider.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(14)
            make.centerY.equalTo(self.unselectedBackground)
            make.centerX.equalTo(self.unselectedBackground).inset(-halfWidth / 2)
        }
        
        halfFuelDivider.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.height.equalTo(22)
            make.centerY.equalTo(self.unselectedBackground)
            make.centerX.equalTo(self.unselectedBackground)
        }
        
        threeQuarterDivider.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(14)
            make.centerY.equalTo(self.unselectedBackground)
            make.centerX.equalTo(self.unselectedBackground).inset(halfWidth / 2)
        }
        
        fullFuelDivider.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.height.equalTo(22)
            make.centerY.equalTo(self.unselectedBackground)
            make.centerX.equalTo(self.unselectedBackground).inset(halfWidth)
        }
    }
    
    private func constrainDividersLabel() {
        noFuelLabel.snp.makeConstraints { make in
            make.top.equalTo(self.noFuelDivider.snp.bottom).offset(10)
            make.left.equalTo(self.noFuelDivider)
        }
        
        oneQuarterLabel.snp.makeConstraints { make in
            make.top.equalTo(self.noFuelLabel)
            make.centerX.equalTo(self.oneQuarterDivider)
        }

        halfFuelLabel.snp.makeConstraints { make in
            make.top.equalTo(self.noFuelLabel)
            make.centerX.equalTo(self.halfFuelDivider)
        }

        threeQuarterLabel.snp.makeConstraints { make in
            make.top.equalTo(self.noFuelLabel)
            make.centerX.equalTo(self.threeQuarterDivider)
        }

        fullFuelLabel.snp.makeConstraints { make in
            make.top.equalTo(self.noFuelLabel)
            make.right.equalTo(self.fullFuelDivider)
        }
    }
    
    private func sendDividersToBack() {
        self.sendSubviewToBack(self.noFuelDivider)
        self.sendSubviewToBack(self.oneQuarterDivider)
        self.sendSubviewToBack(self.halfFuelDivider)
        self.sendSubviewToBack(self.threeQuarterDivider)
        self.sendSubviewToBack(self.fullFuelDivider)
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

extension SteppedFuelSliderView {
    func getMaximumWidth() -> CGFloat {
        return self.frame.width - (self.thumb.frame.width / 2)
    }
    
    func getXRounded(for translation: CGPoint) -> CGFloat {
        return (self.thumb.center.x + translation.x).rounded(.toNearestOrEven)
    }
}
