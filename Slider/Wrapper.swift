import UIKit
import SnapKit

class WrapperView: UIView {
    
    let slider = SteppedFuelSliderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buildViews()
    }
    
    private func buildViews() {
        self.addSubviews()
        self.formatViews()
        self.addConstraintsToSubviews()
    }
    
    private func addSubviews() {
        self.addSubview(self.slider)
    }
    
    private func formatViews() {
        self.backgroundColor = UIColor.white
    }
    
    private func addConstraintsToSubviews() {
        slider.snp.makeConstraints { make in
            make.top.equalTo(self).inset(100)
            make.left.right.equalTo(self).inset(30)
            make.height.equalTo(45)
        }
    }
}

