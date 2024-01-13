//
//  JokeItemCell.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import UIKit

class JokeItemCell: UICollectionViewCell {

    @IBOutlet weak var jokeTextLabel: UILabel!
    @IBOutlet weak var jokeDateLabel: UILabel!
    @IBOutlet weak var jokeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with item: Joke) {
     
        jokeTextLabel.text = item.value
        jokeDateLabel.text = "Date: " + item.created_at
        
        Task {
            let image = await fetchImage(from: item.icon_url)
            await MainActor.run {
                jokeImageView.image = image ?? UIImage(named: "placeholder")
            }
        }
    }
}
