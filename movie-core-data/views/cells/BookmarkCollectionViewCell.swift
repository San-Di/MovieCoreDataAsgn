//
//  BookmarkCollectionViewCell.swift
//  movie-core-data
//
//  Created by Sandi on 9/27/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit

class BookmarkCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookmarkImg: UIImageView!
    
    var data : MovieVO? {
        didSet {
            if let data = data {
                bookmarkImg.sd_setImage(with: URL(string: "\(API.BASE_IMG_URL)\(data.poster_path ?? "")"), completed: nil)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    static var identifier : String {
        return String(describing: self)
    }
}
