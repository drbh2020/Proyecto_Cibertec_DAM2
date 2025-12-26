//
//  FavoritesViewController.swift
//  Proyecto_Cibertec_DAM2
//
//  Created by user286645 on 12/26/25.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!

    private var favorites: [FavoriteSong] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favoritos"
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
    }

    private func loadFavorites() {
        favorites = CoreDataManager.shared.fetchAllFavorites()
        tableView.reloadData()
        emptyLabel.isHidden = !favorites.isEmpty
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! TrackTableViewCell
        cell.configure(with: favorites[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let favorite = favorites[indexPath.row]
        navigateToDetail(favorite: favorite)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favorite = favorites[indexPath.row]
            CoreDataManager.shared.removeFavorite(trackId: Int(favorite.id))
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            emptyLabel.isHidden = !favorites.isEmpty
        }
    }

    private func navigateToDetail(favorite: FavoriteSong) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "TrackDetailViewController") as? TrackDetailViewController {
            // Crear un Track desde FavoriteSong
            let artist = Artist(id: 0, name: favorite.artistName ?? "Unknown", pictureMedium: nil)
            let album = Album(id: 0, title: favorite.albumTitle ?? "Unknown", coverMedium: favorite.coverURL)
            let track = Track(
                id: Int(favorite.id),
                title: favorite.title ?? "Unknown",
                duration: Int(favorite.duration),
                preview: favorite.previewURL ?? "",
                artist: artist,
                album: album
            )
            detailVC.track = track
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
