//
//  NativeADView.swift
//  
//
//  Created by JSilver on 2023/03/30.
//

import SwiftUI
import ChapssalKit
import GoogleMobileAds

final public class TCNativeADView: GADNativeAdView {
    // MARK: - View
    private let adImageView = UIImageView()
    
    private let adIndicatorLabel: UILabel = {
        let view = UILabel()
        view.text = "AD"
        view.font = TR.Font.font(ofSize: 14)
        view.textColor = CR.Color.gray05
        
        return view
    }()
    
    private let adIndicatorContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        
        view.backgroundColor = CR.Color.yellow01
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    private let headlineLabel: UILabel = {
        let view = UILabel()
        view.setContentCompressionResistancePriority(.init(50), for: .horizontal)
        view.font = TR.Font.font(ofSize: 16)
        view.textColor = CR.Color.gray05
        
        return view
    }()
    
    private let headlineStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        
        return view
    }()
    
    private let adDescriptionLabel: UILabel = {
        let view = UILabel()
        view.setContentCompressionResistancePriority(.init(50), for: .horizontal)
        view.font = TR.Font.font(ofSize: 14)
        view.textColor = CR.Color.gray05
        
        return view
    }()
    
    private let adContentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 4
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ nativeAD: GADNativeAd?) {
        adIndicatorContainerView.isHidden = nativeAD == nil
        
        adImageView.image = nativeAD?.icon?.image
        headlineLabel.text = nativeAD?.headline
        adDescriptionLabel.text = nativeAD?.body
        
        nativeAd = nativeAD
    }
    
    private func setUp() {
        setUpLayout()
        setUpState()
        setUpAction()
    }
    
    private func setUpLayout() {
        [
            adIndicatorLabel
        ]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                adIndicatorContainerView.addSubview($0)
            }
        
        NSLayoutConstraint.activate([
            adIndicatorLabel.topAnchor.constraint(equalTo: adIndicatorContainerView.topAnchor, constant: 3),
            adIndicatorLabel.trailingAnchor.constraint(equalTo: adIndicatorContainerView.trailingAnchor, constant: -8),
            adIndicatorLabel.bottomAnchor.constraint(equalTo: adIndicatorContainerView.bottomAnchor, constant: -1),
            adIndicatorLabel.leadingAnchor.constraint(equalTo: adIndicatorContainerView.leadingAnchor, constant: 8)
        ])
        
        [
            adIndicatorContainerView,
            headlineLabel
        ]
            .forEach { headlineStackView.addArrangedSubview($0) }
        
        [
            headlineStackView,
            adDescriptionLabel
        ]
            .forEach { adContentStackView.addArrangedSubview($0) }
        
        [
            adImageView,
            adContentStackView
        ]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
        
        NSLayoutConstraint.activate([
            adImageView.topAnchor.constraint(equalTo: topAnchor),
            adImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            adImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adImageView.heightAnchor.constraint(equalToConstant: 60),
            adImageView.widthAnchor.constraint(equalTo: adImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            adContentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            adContentStackView.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: 16),
            adContentStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setUpState() {
        backgroundColor = CR.Color.gray02
        
        layer.cornerRadius = 8
        clipsToBounds = true
        
        iconView = adImageView
        headlineView = headlineLabel
        bodyView = adDescriptionLabel
    }
    
    private func setUpAction() {
        
    }
}

public struct NativeADView: UIViewRepresentable {
    private var nativeAD: GADNativeAd?
    
    public init(_ nativeAD: GADNativeAd? = nil) {
        self.nativeAD = nativeAD
    }
    
    public func makeUIView(context: Context) -> IntrinsicContentView<TCNativeADView> {
        IntrinsicContentView(TCNativeADView())
    }
    
    public func updateUIView(_ uiView: IntrinsicContentView<TCNativeADView>, context: Context) {
        uiView.content.configure(nativeAD)
    }
}
