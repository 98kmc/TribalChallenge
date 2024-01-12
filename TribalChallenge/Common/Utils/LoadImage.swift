//
//  LoadImage.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import UIKit

// FetchImage from string
func fetchImage(from strg: String) async -> UIImage? {
    
    do {
        guard let url = URL(string: strg) else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    } catch {
        print("Error fetching the image: \(error)")
        return nil
    }
}
