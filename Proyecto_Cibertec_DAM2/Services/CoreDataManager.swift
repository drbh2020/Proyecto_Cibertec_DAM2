//
//  CoreDataManager.swift
//  Proyecto_Cibertec_DAM2
//
//  Created by user286645 on 12/26/25.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    // MARK: - Create
    func saveFavorite(track: Track) {
        // Verificar si ya existe
        if isFavorite(trackId: track.id) { return }

        let favorite = FavoriteSong(context: context)
        favorite.id = Int64(track.id)
        favorite.title = track.title
        favorite.artistName = track.artist.name
        favorite.albumTitle = track.album.title
        favorite.duration = Int32(track.duration)
        favorite.previewURL = track.preview
        favorite.coverURL = track.album.coverMedium
        favorite.addedDate = Date()

        saveContext()
    }

    // MARK: - Read
    func fetchAllFavorites() -> [FavoriteSong] {
        let request: NSFetchRequest<FavoriteSong> = FavoriteSong.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "addedDate", ascending: false)]

        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }

    func isFavorite(trackId: Int) -> Bool {
        let request: NSFetchRequest<FavoriteSong> = FavoriteSong.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", trackId)

        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }

    // MARK: - Delete
    func removeFavorite(trackId: Int) {
        let request: NSFetchRequest<FavoriteSong> = FavoriteSong.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", trackId)

        do {
            let results = try context.fetch(request)
            for object in results {
                context.delete(object)
            }
            saveContext()
        } catch {
            print("Error removing favorite: \(error)")
        }
    }

    // MARK: - Save Context
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
