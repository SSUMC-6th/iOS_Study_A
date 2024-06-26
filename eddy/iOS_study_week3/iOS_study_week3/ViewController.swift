//
//  ViewController.swift
//  iOS_study_week3
//
//  Created by 김의정 on 5/7/24.
//

import UIKit

class ViewController: UIViewController {
    
    var selectedItem: String?
    
    // Create a label to display the data
    let displayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // Set a background color to see the label clearly
        displayLabel.text = selectedItem
        setView()
        setConstraints()
    }
    
    private func setView() {
        view.addSubview(displayLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            displayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            displayLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
