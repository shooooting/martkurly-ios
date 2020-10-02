//
//  CartProductView.swift
//  martkurly
//
//  Created by ㅇ오ㅇ on 2020/09/17.
//  Copyright © 2020 Team3x3. All rights reserved.
//

import UIKit
import Then

class CartProductView: UITableViewCell {

    // MARK: - Properties
    static let identifier = "CartProductView"

    var cartItems: Cart.Items? {
        didSet {
            configure()
        }
    }
    
    private let formatter = NumberFormatter().then {
        $0.numberStyle = .decimal    // 천 단위로 콤마(,)

        $0.minimumFractionDigits = 0    // 최소 소수점 단위
        $0.maximumFractionDigits = 0    // 최대 소수점 단위
    }

    private let inView = UIView().then {
        $0.backgroundColor = .white
    }

    var checkBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        $0.tintColor = .lightGray
        $0.backgroundColor = .white
    }

    var title = UILabel()

    private var productImage = UIImageView().then {
        $0.backgroundColor = .purple
    }

    var condition = UILabel()

    private let discountLabel = UILabel().then {_ in
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.lightGray,
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor.lightGray
        ]
        

    }
    private lazy var discountMoney = UIView().then {
        $0.backgroundColor = .clear
        $0.addSubview(discountLabel)
        
        discountLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    var product = 0 {
        didSet {
            setConstraints()
        }
    }

    private lazy var productPrice = UILabel().then {
        let productPriceAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.black
        ]

        let attributeString = NSAttributedString(
            string: "\(product) 원",
            attributes: productPriceAttributes
        )

        $0.attributedText = attributeString
    }

    private let dismissBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .gray
    }

    private let stepper = KurlyStepper()

    private let total = UILabel().then {
        $0.text = "합계"
    }

    var totalPrice = UILabel().then {
        $0.text = "0"
        $0.font = UIFont.boldSystemFont(ofSize: 15)
    }
    private let totalWon = UILabel().then {
        $0.text = "원"
    }

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private func setConstraints() {

        contentView.backgroundColor = ColorManager.General.backGray.rawValue
        contentView.addSubview(inView)

        [checkBtn, title, dismissBtn, productImage, condition, discountMoney, productPrice, stepper, total, totalPrice, totalWon].forEach {
            inView.addSubview($0)
        }

        stepper.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.bottom.equalTo(productPrice.snp.bottom)
        }

        total.snp.makeConstraints {
            $0.trailing.equalTo(stepper.snp.leading)
            $0.bottom.equalToSuperview().inset(12)
        }

        totalPrice.snp.makeConstraints {
            $0.trailing.equalTo(totalWon.snp.leading).offset(-12)
            $0.bottom.equalTo(total.snp.bottom)
        }

        totalWon.snp.makeConstraints {
            $0.trailing.equalTo(stepper.snp.trailing)
            $0.bottom.equalTo(total.snp.bottom)
        }

        inView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().offset(8).inset(8)
        }

        checkBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(8)
        }

        title.snp.makeConstraints {
            $0.centerY.equalTo(checkBtn.snp.centerY)
            $0.leading.equalTo(checkBtn.snp.trailing).offset(8)
        }

        productImage.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(8)
            $0.leading.equalTo(title.snp.leading)
            $0.height.equalTo(65)
            $0.width.equalTo(50)
        }

        condition.snp.makeConstraints {
            $0.centerX.equalTo(productImage.snp.centerX)
            $0.top.equalTo(productImage.snp.bottom).offset(8)
        }

        condition.text = "냉동"

        discountMoney.snp.makeConstraints {
            $0.bottom.equalTo(productPrice.snp.top).inset(-4)
            $0.leading.equalTo(productPrice.snp.leading)
        }

        productPrice.snp.makeConstraints {
            $0.bottom.equalTo(productImage.snp.bottom)
            $0.leading.equalTo(productImage.snp.trailing).offset(8)
        }

        dismissBtn.snp.makeConstraints {
            $0.centerY.equalTo(title.snp.centerY)
            $0.trailing.equalToSuperview().inset(8)
        }
        dismissBtn.addTarget(self, action: #selector(xmark), for: .touchUpInside)
        dismissBtn.clipsToBounds = true
        dismissBtn.sizeToFit()
    }

    // MARK: - Action
    @objc
    func xmark(_ sender: UIButton) {
        print("hey")
    }

    // MARK: - configure
    func configure() {
        guard let cartItems = cartItems else { return }
        let cartViewModel = CartViewModel(cartItems: cartItems)

    }
}
