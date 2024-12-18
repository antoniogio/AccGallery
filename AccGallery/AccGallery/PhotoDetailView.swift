//
//  PhotoDetailView.swift
//  AccGallery
//
//  Created by Antonio Cortone on 13/12/24.
//
import SwiftUI
import PhotosUI

struct PhotoDetailView: View {
    let photo: Photo

    @State private var showingFullScreenPhoto = false // Stato per aprire l'immagine a schermo intero

    var body: some View {
        VStack {
            Image(uiImage: photo.image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)
                .padding()
                .onTapGesture {
                    showingFullScreenPhoto = true // Apri l'immagine a schermo intero
                }

            Text(photo.title)
                .font(.title)
                .padding(.top)

            if let description = photo.description {
                Text(description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
            }

            Spacer()
        }
        .navigationTitle(photo.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingFullScreenPhoto) {
            FullScreenPhotoView(image: photo.image) // Mostra la vista a schermo intero
        }
    }
}
