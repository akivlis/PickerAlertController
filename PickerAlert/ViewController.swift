//
//  ViewController.swift
//  PickerAlert
//
//  Created by Silvia Kuzmova on 27.01.19.
//  Copyright © 2019 Silvia Kuzmova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let showAlertButton = UIButton()
    let selectedItemLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    @objc func buttonTapped(sender: UIButton!) {
        let alert = PickerAlertController()
        alert.items = ["Apple 🍎", "Pear 🍐", "Banana 🍌", "Carrot 🥕", "Avocado 🥑", " Corn 🌽"]
//        alert.set(title: "Select item", subtitle: "🛒")
        alert.delegate = self
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: PickerAlertViewDelegate

extension ViewController: PickerAlertDelegate {
    func itemSelected(_ item: String) {
        selectedItemLabel.text = "I love \(item)"
    }
}

// MARK: Private

private extension ViewController {
    private func setupViews() {
        showAlertButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        showAlertButton.setTitle("Show alert", for: .normal)
        showAlertButton.setTitleColor(.white, for: .normal)
        showAlertButton.backgroundColor = .red
        view.addSubview(showAlertButton)
        
        view.addSubview(selectedItemLabel)
        selectedItemLabel.textColor = .red
        selectedItemLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
        showAlertButton.translatesAutoresizingMaskIntoConstraints = false
        selectedItemLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            showAlertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showAlertButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showAlertButton.widthAnchor.constraint(equalToConstant: 100),
            showAlertButton.heightAnchor.constraint(equalToConstant: 30),
            
            selectedItemLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectedItemLabel.topAnchor.constraint(equalTo: showAlertButton.bottomAnchor, constant: 20),
            selectedItemLabel.widthAnchor.constraint(equalToConstant: 200),
            selectedItemLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
}

