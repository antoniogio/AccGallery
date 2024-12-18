//
//  ContentView.swift
//  AccGallery
//
//  Created by Antonio Cortone on 13/12/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var photos: [Photo] = [] {
        didSet {
            savePhotos()
        }
    }

    @State private var showingAddPhotoView = false
    @State private var searchText = ""
    @State private var sortOption: SortOption = .byChronologicalAscending

    
    var sortedAndFilteredPhotos: [Photo] {
        let sortedPhotos: [Photo]
        switch sortOption {
        case .byAlphabetical:
            sortedPhotos = photos.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .byChronologicalAscending:
            sortedPhotos = photos
        case .byChronologicalDescending:
            sortedPhotos = photos.reversed()
        }
        
        if searchText.isEmpty {
            return sortedPhotos
        } else {
            return sortedPhotos.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("Sort By", selection: $sortOption) {
                    Text("Alphabetical").tag(SortOption.byAlphabetical)
                    Text("Chronological ↑").tag(SortOption.byChronologicalAscending)
                    Text("Chronological ↓").tag(SortOption.byChronologicalDescending)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if photos.isEmpty {
                    VStack {
                        Text("No photos added yet.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGray6))
                } else if sortedAndFilteredPhotos.isEmpty {
                    VStack {
                        Text("No matching titles found.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGray6))
                } else {
                    List {
                        ForEach(sortedAndFilteredPhotos) { photo in
                            NavigationLink(destination: PhotoDetailView(photo: photo)) {
                                Text(photo.title)
                            }
                        }
                        .onDelete(perform: deletePhoto)
                    }
                }
                Spacer()
                HStack {
                    TextField("Search photos", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                .background(Color(.systemGray6))
            }
            .navigationTitle("Photo Gallery")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddPhotoView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPhotoView) {
                AddPhotoView(photos: $photos)
            }
            .onAppear(perform: loadPhotos)

        }
    }

    func deletePhoto(at offsets: IndexSet) {
        photos.remove(atOffsets: offsets)
    }
    func savePhotos() {
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(photos) {
                UserDefaults.standard.set(encodedData, forKey: "SavedPhotos")
            }
        }

        func loadPhotos() {
            let decoder = JSONDecoder()
            if let savedData = UserDefaults.standard.data(forKey: "SavedPhotos"),
               let loadedPhotos = try? decoder.decode([Photo].self, from: savedData) {
                photos = loadedPhotos
            }
        }
}

enum SortOption: String, CaseIterable {
    case byAlphabetical
    case byChronologicalAscending
    case byChronologicalDescending
}

#Preview {
    ContentView()
}
