//
//  Photo.swift
//  AccGallery
//
//  Created by Antonio Cortone on 13/12/24.
//
import SwiftUI
import PhotosUI

struct Photo: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String?
    var imageData: Data // Salva l'immagine come Data

    init(id: UUID = UUID(), title: String, description: String?, image: UIImage) {
        self.id = id
        self.title = title
        self.description = description
        self.imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
    }

    var image: UIImage {
        UIImage(data: imageData) ?? UIImage()
    }
}


