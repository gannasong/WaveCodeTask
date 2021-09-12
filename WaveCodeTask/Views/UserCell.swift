//
//  UserCell.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import UIKit
import SnapKit

class UserCell: UICollectionViewCell {
  private lazy var imageView: UIImageView = {
    let view = UIImageView(frame: .zero)
    view.contentMode = .scaleAspectFill
    view.clipsToBounds = true
    view.layer.cornerRadius = 10
    return view
  }()

  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .boldSystemFont(ofSize: 16)
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.9
    label.lineBreakMode = .byTruncatingTail
    label.text = "Default"
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    nameLabel.text = ""
    imageView.image = UIImage(named: "placeholder")
  }

  // MARK: - Public Methods

  public func configure(model: User) {
    nameLabel.text = model.login
    imageView.setImage(with: model.avatar_url)
  }

  // MARK: - Private Methods

  private func setupSubviews() {
    contentView.addSubview(imageView)
    contentView.addSubview(nameLabel)

    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(4)
      $0.left.equalToSuperview().offset(4)
      $0.right.equalToSuperview().offset(-4)
      $0.width.equalTo(imageView.snp.height)
    }

    nameLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(8)
      $0.left.equalTo(imageView.snp.left)
      $0.right.equalTo(imageView.snp.right)
      $0.height.equalTo(20)
    }
  }
}
