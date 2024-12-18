//
//  EditPhotoView.swift
//  AccGallery
//
//  Created by Antonio Cortone on 13/12/24.
//
import SwiftUI
import PhotosUI


struct EditPhotoView: View {
    let photo: Photo
    @Binding var photos: [Photo]

    @State private var title: String
    @State private var description: String
    @Environment(\.dismiss) var dismiss

    init(photo: Photo, photos: Binding<[Photo]>) {
        self.photo = photo
        self._photos = photos
        self._title = State(initialValue: photo.title)
        self._description = State(initialValue: photo.description ?? "")
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }

                Section(header: Text("Description (Optional)")) {
                    TextField("Enter description", text: $description)
                }
            }
            .navigationTitle("Edit Photo")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let index = photos.firstIndex(where: { $0.id == photo.id }) {
                            photos[index].title = title
                            photos[index].description = description.isEmpty ? nil : description
                        }
                        dismiss()
                    }
                }
            }
        }
    }
}
