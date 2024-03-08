//
//  JokesView.swift
//  Jokes
//
//  Created by Adriano Rodrigues Vieira on 05/02/24.
//

import UIKit
import SkeletonView

final class JokesView: UIView {
    private(set) lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.backgroundColor = .systemBlue
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .timesNewRoman15

        return button
    }()

    private(set) lazy var setupLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.isSkeletonable = true
        label.font = .timesNewRoman15

        return label
    }()

    private(set) lazy var punchlineLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.isSkeletonable = true
        label.font = .timesNewRomanItalic13

        return label
    }()

    private(set) lazy var typeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.isSkeletonable = true
        label.font = .timesNewRomanBold11

        return label
    }()


    private lazy var stack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.layoutMargins = .zero
        stack.addArrangedSubview(setupLabel)
        stack.addArrangedSubview(punchlineLabel)
        stack.addArrangedSubview(typeLabel)
        stack.addArrangedSubview(button)

        stack.setCustomSpacing(12, after: punchlineLabel)

        return stack
    }()

    init() {
        super.init(frame: .zero)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        isSkeletonable = true
        addSubview(stack)

        NSLayoutConstraint.activate(
            [
                button.heightAnchor.constraint(equalToConstant: 48),
                stack.centerYAnchor.constraint(equalTo: centerYAnchor),
                stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
            ]
        )

        backgroundColor = .white
    }
}
