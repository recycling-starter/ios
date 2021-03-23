//
//  BoxCell.swift
//  RecyclingStarter
//
//  Created by  Matvey on 03.01.2021.
//  Copyright © 2021 Borisov Matvei. All rights reserved.
//

import UIKit
import TinyConstraints
import SwiftRichString

class BoxCell: UITableViewCell {
    
    private let progressBar = CircleProgressBarView(lineWidth: 4, frame: CGRect(x: 0, y: 0, width: 56, height: 56))
    private let idLabel = UILabel()
    private let fullnessLabel = UILabel()
    private let roomLabel = UILabel()
    private var fullnes = 0
    private var isAnimated = false
    
    private enum Style {
        static let percentStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.medium14
            $0.color = AppColor.placeholder
        }
        
        static let textStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.medium16
            $0.color = AppColor.label
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        
        contentView.addSubview(progressBar)
        contentView.addSubview(idLabel)
        contentView.addSubview(fullnessLabel)
        contentView.addSubview(roomLabel)
        
        progressBar.topToSuperview(offset: 19)
        progressBar.leadingToSuperview(offset: 19)
        progressBar.bottomToSuperview(offset: -19)
        progressBar.width(56)
        progressBar.height(56)
        
        idLabel.topToSuperview(offset: 19)
        idLabel.leadingToTrailing(of: progressBar, offset: 16)
        idLabel.trailingToSuperview(offset: 20)
        
        fullnessLabel.center(in: progressBar)
        
        roomLabel.topToBottom(of: idLabel, offset: 16)
        roomLabel.leading(to: idLabel)
        roomLabel.trailingToSuperview(offset: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.layer.borderColor = AppColor.cellBorderColor?.cgColor
        self.clipsToBounds = true
    }
    
    
    func configute(with boxData: BoxData) {
        fullnes = boxData.fullness
        idLabel.attributedText = "Контейнер \(boxData.id)".set(style: Style.textStyle)
        fullnessLabel.attributedText = "\(fullnes)%".set(style: Style.percentStyle)
        roomLabel.attributedText = "Кабинет \(boxData.room)".set(style: Style.textStyle)
        if !isAnimated {
            isAnimated = true
            progressBar.progressAnimation(duration: 0.5, progress: fullnes)
        } else {
            progressBar.drawFill(progress: fullnes)
        }
    }
}
