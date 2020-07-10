import UIKit

final class MainView: UIView {
    var titleLabel: UILabel!
    var sortedLabel: UILabel!
    var switchControl: UISwitch!
    var switchLeftLabel: UILabel!
    var switchRightLabel: UILabel!
    var tableView: UITableView!
    var activityIndicator: UIActivityIndicatorView!

    init() {
        super.init(frame: .zero)
        layoutContent(in: self)
        applyStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutContent(in view: UIView) {
        titleLabel = layout(UILabel(text: "Hotel List")) { make in
            make.top.equalTo(safeArea).offset(20)
            make.centerX.equalToSuperview()
        }

        sortedLabel = layout(UILabel(text: "sorted by:")) { make in
            make.top.equalTo(titleLabel.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        switchControl = layout(UISwitch()) { make in
            make.top.equalTo(sortedLabel.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        switchLeftLabel = layout(UILabel(text: "distance")) { make in
            make.centerY.equalTo(switchControl)
            make.trailing.equalTo(switchControl.leading).offset(-10)
        }

        switchRightLabel = layout(UILabel(text: "free rooms")) { make in
            make.centerY.equalTo(switchControl)
            make.leading.equalTo(switchControl.trailing).offset(10)
        }

        tableView = layout(UITableView()) { make in
            make.top.equalTo(switchControl.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(safeArea)
        }

        activityIndicator = layout(UIActivityIndicatorView()) { make in
            make.center.equalToSuperview()
        }
    }

    private func applyStyle() {
        backgroundColor = .white
        sortedLabel.font = .systemFont(ofSize: 13)
        switchLeftLabel.font = .systemFont(ofSize: 13)
        switchRightLabel.font = .systemFont(ofSize: 13)
        activityIndicator.style = UIActivityIndicatorView.Style.medium
    }
}
