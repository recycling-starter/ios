//
//  BoxCell.swift
//  RecyclingStarter
//
//  Created by  Matvey on 03.01.2021.
//  Copyright © 2021 Borisov Matvei. All rights reserved.
//

import UIKit
import TinyConstraints

class BoxCell: UITableViewCell {
    
    private let idLabel = UILabel()
    private let fullnessLabel = UILabel()
    private let roomLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        
        contentView.addSubview(idLabel)
        contentView.addSubview(fullnessLabel)
        contentView.addSubview(roomLabel)
        
        idLabel.topToSuperview(offset: 10)
        idLabel.leadingToSuperview(offset: 15)
        idLabel.trailingToSuperview(offset: 20)
        
        fullnessLabel.topToBottom(of: idLabel, offset: 15)
        fullnessLabel.leadingToSuperview(offset: 15)
        fullnessLabel.trailingToSuperview(offset: 20)
        
        roomLabel.topToBottom(of: fullnessLabel, offset: 15)
        roomLabel.leadingToSuperview(offset: 15)
        roomLabel.trailingToSuperview(offset: 20)
        roomLabel.bottomToSuperview(offset: -5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configute(with boxData: BoxData) {
        idLabel.text = "Box \(boxData.id)"
        idLabel.backgroundColor = .blue
        fullnessLabel.text = "Full on \(boxData.fullness)%"
        fullnessLabel.backgroundColor = .cyan
        roomLabel.text = "In room \(boxData.room)"
        roomLabel.backgroundColor = .yellow
    }
}
