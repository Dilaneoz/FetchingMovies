//
//  SearchTableViewCell.swift
//  FilmApp
//
//  Created by Opendart Yazılım ve Bilişim Hizmetleri on 12.03.2023.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchMovieName: UILabel!
    @IBOutlet weak var searchReleaseDate: UILabel!
    @IBOutlet weak var searchTotalView: UILabel!
    @IBOutlet weak var searchVoteAvarage: UILabel!
    @IBOutlet weak var searchFilmImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
