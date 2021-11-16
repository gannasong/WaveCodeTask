//
//  GithubSearchViewController.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay
import RxCocoa
import MBProgressHUD

final class GithubSearchViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let searchUserTrigger = PublishSubject<SearchResultViewModel.SearchType>()
  private let cancelTrigger = PublishSubject<Void>()
  private let isLoading = BehaviorRelay<Bool>(value: false)
  private let canLoadMore = BehaviorRelay<Bool>(value: false)
  private let viewModel: SearchResultViewModel

  private lazy var searchTextField: UITextField = {
    let view = UITextField()
    view.delegate = self
    view.borderStyle = .roundedRect
    view.returnKeyType = .search
    view.clearButtonMode = .whileEditing
    view.placeholder = "Search for a username"
    return view
  }()

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    collectionView.backgroundColor = .white
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 28, right: 0)
    return collectionView
  }()

  private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    layout.minimumLineSpacing = 30
    layout.itemSize = CGSize(width: (view.bounds.width / 3) - 10, height: (view.bounds.width / 3) - 10)
    return layout
  }()

  private lazy var emptyView: EmptyView = {
    let emptyView = EmptyView()
    emptyView.isHidden = false
    return emptyView
  }()

  private lazy var loadingHUD: MBProgressHUD = {
    let loadingHUD = MBProgressHUD.showAdded(to: view, animated: false)
    return loadingHUD
  }()

  // MARK: - Initialization

  init(viewModel: SearchResultViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    title = "Github Search"
    sutupSubview()
    searchTextField.delegate = self
    collectionView.delegate = self
    collectionView.register(UserCell.self, forCellWithReuseIdentifier: "UserCell")
    bindTo(viewModel)
  }

  // MARK: - Private Methods

  private func sutupSubview() {
    view.backgroundColor = .white
    view.addSubview(searchTextField)
    view.addSubview(collectionView)
    view.addSubview(emptyView)

    searchTextField.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
      $0.width.equalToSuperview().offset(-20)
      $0.height.equalTo(40)
      $0.centerX.equalToSuperview()
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(searchTextField.snp.bottom).offset(8)
      $0.width.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.centerX.equalToSuperview()
    }

    emptyView.snp.makeConstraints {
      $0.top.equalTo(searchTextField.snp.bottom).offset(8)
      $0.width.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
  }

  private func bindTo(_ viewModel: SearchResultViewModel?) {
    guard let viewModel = viewModel else { return }

    let searchTrigger = searchUserTrigger.throttle(.milliseconds(500), scheduler: MainScheduler.instance)
    let input = SearchResultViewModel.Input(searchUserTrigger: searchTrigger, cancelTrigger: cancelTrigger)
    let output = viewModel.transform(input: input)

    output.list
      .do { [weak self] list in
        self?.emptyView.isHidden = !list.isEmpty
      }
      .bind(to: collectionView.rx.items) { collectionView, row, user in
        let indexPath = IndexPath(row: row, section: 0)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.configure(model: user)
        return cell
      }.disposed(by: disposeBag)

    output.isLoading
      .bind(to: isLoading)
      .disposed(by: disposeBag)

    isLoading
      .map { !$0 }
      .bind(to: loadingHUD.rx.isHidden)
      .disposed(by: disposeBag)

    output.loadError
      .subscribe { [weak self] event in
        guard let message = event.element else { return }
        self?.showMessageBanner(theme: .error, title: "Error", message: message)
      }.disposed(by: disposeBag)

    output.canLoadMore
      .bind(to: canLoadMore)
      .disposed(by: disposeBag)
  }
}

extension GithubSearchViewController: UITextFieldDelegate {
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard isLoading.value == false else {
      let message = "The service is loading，please wait a moment."
      self.showMessageBanner(theme: .warning, title: "Warning", message: message)
      return true
    }

    guard let text = textField.text, !text.isEmpty else {
      let message = "Can't search empty name, please try again."
      self.showMessageBanner(theme: .warning, title: "Warning", message: message)
      return true
    }

    searchUserTrigger.onNext(.newSearch(name: text))
    view.endEditing(true)
    return true
  }

  public func textFieldShouldClear(_ textField: UITextField) -> Bool {
    cancelTrigger.onNext(())
    return true
  }
}

extension GithubSearchViewController: UICollectionViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard scrollView.isDragging && isLoading.value == false && canLoadMore.value == true else { return }

    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    if (offsetY > contentHeight - scrollView.frame.height) {
      searchUserTrigger.onNext(.requestNextPage)
    }
  }
}
