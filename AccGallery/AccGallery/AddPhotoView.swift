//
//  AddPhotoView.swift
//  AccGallery
//
//  Created by Antonio Cortone on 13/12/24.
//

import SwiftUI
import PhotosUI

struct AddPhotoView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var photos: [Photo]

    @State private var selectedImage: UIImage? = nil
    @State private var title = ""
    @State private var description = ""
    @State private var showingImagePicker = false

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Text(selectedImage == nil ? "Select Image" : "Change Image")
                    }

                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding(.top)
                    }
                }

                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }

                Section(header: Text("Description (Optional)")) {
                    TextField("Enter description", text: $description)
                }
            }
            .navigationTitle("Add Photo")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let selectedImage = selectedImage, !title.isEmpty {
                            let newPhoto = Photo(title: title, description: description.isEmpty ? nil : description, image: selectedImage)
                            photos.append(newPhoto)
                            dismiss()
                        }
                    }
                    .disabled(selectedImage == nil || title.isEmpty)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
}
