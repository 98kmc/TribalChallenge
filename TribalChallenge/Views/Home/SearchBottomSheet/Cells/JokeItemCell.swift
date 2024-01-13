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
            jokeImageView.image = await fetchImage(from: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.facebook.com%2FTribalLatAm%2F&psig=AOvVaw2VZt82RWYHkzRemCIDbPHx&ust=1705201489397000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCOjH6Nyw2YMDFQAAAAAdAAAAABAD")
        }
    }
}
