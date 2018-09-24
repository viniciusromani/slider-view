import UIKit
import SnapKit

class SliderView: UIView {
    
    var minValue: Float = 0 {
        didSet {
            currentPrice = round(maxValue)
        }
    }
    var maxValue: Float = 400 {
        didSet {
            currentPrice = round(maxValue)
        }
    }
    
    var suggestedPrice: Float {
        didSet {
            self.suggestionLabel.text = String(Int(round(suggestedPrice)))
        }
    }
    
    let suggestionLabel = UILabel()
    let suggestionDivider = UIView()
    
    let valuePrefix = "R$ "
    
    var currentPrice: Float {
        didSet {
            self.priceValue.text = self.formatValue(Float(currentPrice))
            //self.setThumbPosition(on: Float(currentPrice))
        }
    }
    
    func formatValue(_ value: Float) -> String {
        let prefix = valuePrefix
        let valueString = String(format: "%.0f", value)
        
        return prefix + valueString
    }
    
    let selectedBackground = UIView()
    let unselectedBackground = UIView()
    
    let thumb = UIImageView(image: UIImage(named: "group2"))
    let priceValue = UILabel()
    let priceTouchArea = UIView()
    
    var thumbConstraint: Constraint?
    
    override init(frame: CGRect) {
        self.suggestedPrice = round(maxValue)
        self.currentPrice = round(maxValue)
        super.init(frame: frame)
        self.buildViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.suggestedPrice = round(maxValue)
        self.currentPrice = round(maxValue)
        super.init(coder: aDecoder)
        self.buildViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //self.setThumbPosition(on: Float(currentPrice))
    }
    
    private func buildViews() {
        self.addSubviews()
        self.formatViews()
        self.addConstraintsToSubviews()
        
        self.currentPrice = round(maxValue)
    }
    
    private func addSubviews() {
        self.addSubview(self.unselectedBackground)
        self.addSubview(self.selectedBackground)
        
        self.addSubview(self.suggestionLabel)
        self.addSubview(self.suggestionDivider)
        
        self.addSubview(self.thumb)
        self.addSubview(self.priceValue)
        self.addSubview(self.priceTouchArea)
    }
    
    private func formatViews() {
        
        self.selectedBackground.layer.cornerRadius = 3
        self.selectedBackground.backgroundColor = UIColor.orange
        
        self.unselectedBackground.layer.cornerRadius = 3
        self.unselectedBackground.backgroundColor = UIColor.lightGray
        
        let thumbGesture = UIPanGestureRecognizer(target: self, action: #selector(thumbDidMove(_:)))
        self.priceTouchArea.addGestureRecognizer(thumbGesture)
        
        self.priceValue.numberOfLines = 2
        self.priceValue.textColor = .red
        
        self.suggestionDivider.backgroundColor = UIColor.orange
        
        self.suggestionLabel.numberOfLines = 0
    }
    
    private func addConstraintsToSubviews() {
        let xw = 24
        
        thumb.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(self)
            make.width.height.equalTo(xw)
            make.bottom.equalTo(self.priceValue.snp.top).inset(-4)
        }
        
        priceValue.snp.makeConstraints { make in
            make.centerX.equalTo(self.thumb).priority(800)
            make.bottom.lessThanOrEqualTo(self)
        }
        
        priceTouchArea.snp.makeConstraints { make in
            make.top.equalTo(self.thumb)
            make.left.right.bottom.equalTo(self.priceValue)
        }
        
        unselectedBackground.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(xw / 2)
            make.height.equalTo(5)
        }
        
        selectedBackground.snp.makeConstraints { make in
            make.height.equalTo(6)
            make.left.centerY.equalTo(self.unselectedBackground)
            make.right.equalTo(self.thumb).inset(xw / 2)
        }
        
        thumb.snp.makeConstraints { make in
            make.centerY.equalTo(self.selectedBackground).inset(1)
            self.thumbConstraint = make.right.equalTo(self).constraint
        }
        
        thumb.setContentCompressionResistancePriority(.required, for: .horizontal)
        priceValue.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        suggestionDivider.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.equalTo(2)
            make.height.equalTo(22)
            make.centerY.equalTo(self.unselectedBackground)
        }
        
        suggestionLabel.snp.makeConstraints { make in
            make.top.centerX.equalTo(self)
            make.bottom.equalTo(self.suggestionDivider.snp.top)
        }
    }
    
    @objc func thumbDidMove(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        
        let current = self.thumbConstraint?.layoutConstraints.first?.constant ?? 0
        var new: CGFloat = 0
        let newPosition = current + translation.x
        
        if newPosition >= 0 {
            new = 0
        } else if newPosition <= 0 - self.bounds.width + self.thumb.bounds.width {
            new = -self.bounds.width + self.thumb.bounds.width
            recognizer.setTranslation(CGPoint.zero, in: self)
        } else {
            new = newPosition
            recognizer.setTranslation(CGPoint.zero, in: self)
        }
        
        let size = self.bounds.width - self.thumb.bounds.width
        let percent = 1 + new / size
        
        let secondHalf = percent > 0.5
        let localPercent = (secondHalf ? percent - 0.5 : percent) * 2
        let localMax = secondHalf ? maxValue : Float(suggestedPrice)
        let localMin = secondHalf ? Float(suggestedPrice) : minValue
        
        let value = Float(localPercent) * (localMax - localMin) + (localMin)
        
        self.currentPrice = round(value)
        
        self.thumb.snp.updateConstraints { make in
            self.thumbConstraint = make.right.equalTo(self).offset(new).constraint
        }
    }
    
    func setThumbPosition(on value: Float) {
        let secondHalf = value > suggestedPrice
        let localMax = secondHalf ? maxValue : Float(suggestedPrice)
        let localMin = secondHalf ? Float(suggestedPrice) : minValue
        
        let position = ((CGFloat(value) - CGFloat(localMin)) / CGFloat(localMax - localMin) - 1) * (self.bounds.width - self.thumb.bounds.width) / 2
        print("position \(position)")
        
        self.thumb.snp.updateConstraints { make in
            self.thumbConstraint = make.right.equalTo(self).inset(position).constraint
        }
    }
}

fileprivate func round(_ value: Float) -> Float {
    return value.rounded(.toNearestOrEven)
}
