//
//  PostCell.swift
//  ios101-project5-tumblr
//
//  Created by Mubashirul Islam on 4/3/25.
//

import UIKit

class PostCell: UITableViewCell {

    
    @IBOutlet weak var PostImage: UIImageView!
    
    
    @IBOutlet weak var PostButton: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
