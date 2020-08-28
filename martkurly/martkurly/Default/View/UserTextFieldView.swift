//
//  UserTextFieldView.swift
//  martkurly
//
//  Created by Doyoung Song on 8/20/20.
//  Copyright © 2020 Team3x3. All rights reserved.
//

import UIKit

class UserTextFieldView: UIView {

    // MARK: - Properties
    let textField = UITextField()
    private let placeholder = UILabel().then {
        $0.textColor = ColorManager.General.placeholder.rawValue
    }
    private var isActive = false {
        willSet {
            configureTextFieldStatus(newValue: newValue)
        }
    }
    var text: String? { // 텍스트필드의 값을 반환
        get {
            return self.textField.text
        }
    }
    private var subtitles: [String]?
    private var viewSizeHandler: ( () -> Void )?
    private var subtitleLabels: [UILabel] = []
    var isEditing = false

    // MARK: - Lifecycle
    init(placeholder: String, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.placeholder.text = placeholder
        self.placeholder.font = UIFont.systemFont(ofSize: fontSize)
        configureUI()
    }

    init(placeholder: String, fontSize: CGFloat, subtitles: [String]?, viewSizeHandler: @escaping () -> Void) {
        super.init(frame: .zero)
        self.placeholder.text = placeholder
        self.placeholder.font = UIFont.systemFont(ofSize: fontSize)
        self.subtitles = subtitles
        self.viewSizeHandler = viewSizeHandler
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
        generateSubtitles()
    }

    private func setPropertyAttributes() {
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorManager.General.placeholder.rawValue.cgColor
        self.layer.cornerRadius = 4

        self.textField.delegate = self
    }

    private func setConstraints() {
        [textField, placeholder].forEach {
            self.addSubview($0)
        }
        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
        placeholder.snp.makeConstraints {
            $0.leading.equalTo(textField)
            $0.centerY.equalToSuperview()
        }
    }

    private func generateSubtitles() {
        guard let subtitles = subtitles else { return }
        var isFirstSubtitle = true
        var previousLabel = UILabel()
        for subtitle in subtitles {
            let label = UILabel().then {
                $0.text = subtitle
                $0.textColor = .chevronGray
                $0.font = UIFont.systemFont(ofSize: 13)
                $0.alpha = 0
            }
            self.addSubview(label)
            subtitleLabels.append(label)
            if isFirstSubtitle {
                label.snp.makeConstraints {
                    $0.top.equalTo(textField.snp.bottom).offset(12)
                    $0.leading.equalToSuperview()
                }
                isFirstSubtitle = false
            } else {
                label.snp.makeConstraints {
                    $0.top.equalTo(previousLabel.snp.bottom).offset(2)
                    $0.leading.equalTo(previousLabel)
                }
            }
            previousLabel = label
        }
    }

    // MARK: - Helpers
    private func configureTextFieldStatus(newValue: Bool) {
        switch newValue {
        case true:
            self.placeholder.alpha = 0
        case false:
            self.placeholder.alpha = 1
        }
    }

    private func showSubtitleLabels() {
        subtitleLabels.forEach {
            $0.alpha = 1
        }
    }
}

// MARK: - UITextFieldDelegate
extension UserTextFieldView: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.isActive = text?.isEmpty == true ? false : true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let _ = subtitles,
            let cellSizeHandler = viewSizeHandler
            else { return true }
        cellSizeHandler()
        showSubtitleLabels()
        return true
    }
}
