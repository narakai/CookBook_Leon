//
//  MainCustomCell.swift
//  CookBook_Leon
//
//  Created by lai leon on 2017/12/21.
//  Copyright © 2017 clem. All rights reserved.
//

import UIKit

class MainCustomCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    let title: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 80, y: 10, width: YHWidth - 80 - 40, height: 40)
        title.font = UIFont.systemFont(ofSize: 16)
        title.numberOfLines = 0
        title.textColor = .black
        return title
    }()

    let detail: UILabel = {
        let detail = UILabel()
        detail.frame = CGRect(x: 80, y: 50, width: YHWidth - 80 - 40, height: 20)
        detail.font = UIFont.systemFont(ofSize: 12)
        detail.textColor = .gray
        return detail
    }()

    let showImage: UIImageView = {
        let showImage = UIImageView()
        showImage.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        return showImage
    }()


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        addSubview(showImage)
        addSubview(detail)
        addSubview(title)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func buildUI(data: ShowData) {
        title.text = data.title
        detail.text = data.jianjie
        NetManager.share.downImage(imageView: showImage, imageURL: URL(string: data.thumb)!)
    }


}
