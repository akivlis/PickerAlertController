//
//  PickerAlertController.swift
//  PickerAlert
//
//  Created by Silvia Kuzmova on 27.01.19.
//  Copyright © 2019 Silvia Kuzmova. All rights reserved.
//

import UIKit

class PickerAlertController: UIViewController {
    
    var delegate: PickerAlertDelegate?
    
    var items: [String] = [String]()
    {
        didSet {
            selectedItem = items.first ?? ""
        }
    }

    private var selectedItem: String = ""
    
    private lazy var alertView = UIView()
    private lazy var mainStackView = UIStackView()
    private lazy var roundedContainerView = UIView()
    private lazy var pickerView = UIPickerView()
    private lazy var headerView = PickerAlertHeaderView()
    private lazy var confirmationButton = UIButton()
    
    private var backgroundTap = UITapGestureRecognizer()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        alertView.layer.shadowPath = UIBezierPath(roundedRect: alertView.bounds, cornerRadius: 6).cgPath
    }
    
    func set(title: String, subtitle: String) {
        headerView.titleLabel.text = title
        headerView.subtitleLabel.text = subtitle
    }
}

// MARK: - UIPickerViewDataSource

extension PickerAlertController: UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return items.count
    }
}

// MARK: - UIPickerViewDelegate

extension PickerAlertController: UIPickerViewDelegate {
    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return items[row]
    }
    
    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        selectedItem = items[row]
    }
    
    func pickerView(_: UIPickerView, widthForComponent _: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_: UIPickerView, viewForRow row: Int, forComponent _: Int, reusing view: UIView?) -> UIView {
        if view == nil {
            let label = UILabel()
            label.textAlignment = .center
            label.text = items[row]
            return label
        } else {
            return view!
        }
    }
}

private extension PickerAlertController {
    private func commonInit() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        backgroundTap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
        view.addGestureRecognizer(backgroundTap)
        
        alertView.layer.masksToBounds = false
        alertView.layer.shadowOffset = CGSize(width: 0, height: 0)
        alertView.layer.shadowRadius = 8
        alertView.layer.shadowOpacity = 0.3
        alertView.backgroundColor = .clear
        view.addSubview(alertView)
        
        roundedContainerView.backgroundColor = UIColor.white
        roundedContainerView.layer.cornerRadius = 6.0
        roundedContainerView.clipsToBounds = true
        alertView.addSubview(roundedContainerView)
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        roundedContainerView.addSubview(mainStackView)
        
        headerView.backgroundColor = .red
        headerView.titleLabel.textColor = .white
        headerView.subtitleLabel.textColor = .white
        mainStackView.addArrangedSubview(headerView)
        
        mainStackView.addArrangedSubview(pickerView)
        
        confirmationButton.setTitle("Select", for: .normal)
        confirmationButton.setTitleColor(.red, for: .normal)
        confirmationButton.addTarget(self, action: #selector(confirmationButtonTapped), for: .touchUpInside)
        
        mainStackView.addArrangedSubview(confirmationButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            roundedContainerView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            roundedContainerView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            roundedContainerView.topAnchor.constraint(equalTo: alertView.topAnchor),
            roundedContainerView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor),
            
            mainStackView.trailingAnchor.constraint(equalTo: roundedContainerView.trailingAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: roundedContainerView.leadingAnchor),
            mainStackView.topAnchor.constraint(equalTo: roundedContainerView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: roundedContainerView.bottomAnchor),
            ])
        
        alertView.translatesAutoresizingMaskIntoConstraints = false
        roundedContainerView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

    }
    
    @objc func confirmationButtonTapped(sender: UIButton!) {
        delegate?.itemSelected(selectedItem)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func backgroundTapped(_ recognizer: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

fileprivate class PickerAlertHeaderView: UIView {
    lazy var titleLabel = UILabel()
    lazy var subtitleLabel = UILabel()
    
    private lazy var stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

private extension PickerAlertHeaderView {
    private func commonInit() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        addSubview(stackView)
        
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
        
        subtitleLabel.textAlignment = .center
        stackView.addArrangedSubview(subtitleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
}
