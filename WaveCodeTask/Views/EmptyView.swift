//
//  EmptyView.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import UIKit
import SnapKit

final class EmptyView: UIView {

  private lazy var messageLabel: UILabel = {
    let messageLabel = UILabel()
    messageLabel.numberOfLines = 3
    messageLabel.textAlignment = .center
    messageLabel.font = UIFont.boldSystemFont(ofSize: 28)
    messageLabel.textColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 0.6)
    messageLabel.adjustsFontSizeToFitWidth = true
    messageLabel.minimumScaleFactor = 0.9
    messageLabel.lineBreakMode = .byTruncatingTail
    messageLabel.text = "Search result is empty"
    return messageLabel
  }()

  private lazy var logoImageVeiw: UIImageView = {
    let logoImageVeiw = UIImageView()
    logoImageVeiw.image = UIImage(named: "empty-logo")
    logoImageVeiw.contentMode = .scaleAspectFill
    return logoImageVeiw
  }()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private methods

  private func setupSubviews() {
    backgroundColor = .white
    addSubview(messageLabel)
    addSubview(logoImageVeiw)

    messageLabel.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(200)
      $0.centerY.equalTo(self.snp.centerY).offset(-100)
    }

    logoImageVeiw.snp.makeConstraints {
      $0.centerX.equalTo(self.snp.right)
      $0.bottom.equalToSuperview().offset(100)
    }
  }
}
