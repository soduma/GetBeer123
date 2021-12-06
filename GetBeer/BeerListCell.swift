//
//  BeerListCell.swift
//  GetBeer
//
//  Created by 장기화 on 2021/12/06.
//

import UIKit
import SnapKit
import Kingfisher

class BeerListCell: UITableViewCell {

    let beerImageView = UIImageView()
    let nameLabel = UILabel()
    let tagLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [beerImageView, nameLabel, tagLabel].forEach {
            contentView.addSubview($0)
        }
        
        beerImageView.contentMode = .scaleAspectFit
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.numberOfLines = 2
        tagLabel.font = .systemFont(ofSize: 14, weight: .light)
        tagLabel.textColor = .systemBrown
        tagLabel.numberOfLines = 0
        
        beerImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.top.bottom.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(120)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(beerImageView.snp.trailing).offset(10)
            $0.bottom.equalTo(beerImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        tagLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
    }
    
    func configure(with beer: Beer) {
        let imageURL = URL(string: beer.image_url ?? "")
        beerImageView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "beer_icon.png"))
        nameLabel.text = beer.name ?? "이름 없는 맥주"
        tagLabel.text = beer.hashTag
        
        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }
}
