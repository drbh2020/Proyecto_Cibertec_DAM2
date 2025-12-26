//
//  SearchViewController.swift
//  Proyecto_Cibertec_DAM2
//
//  Created by user286645 on 12/26/25.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let searchController = UISearchController(searchResultsController: nil)
    private var tracks: [Track] = []
    private var searchWorkItem: DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buscar"
        setupSearchController()
        setupTableView()
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar canciones o artistas"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
    }

    private func searchTracks(query: String) {
        // Cancelar búsqueda anterior
        searchWorkItem?.cancel()

        // Debounce de 0.5 segundos
        let workItem = DispatchWorkItem { [weak self] in
            NetworkManager.shared.searchTracks(query: query) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let tracks):
                        self?.tracks = tracks
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print("Search error: \(error)")
                    }
                }
            }
        }

        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            tracks = []
            tableView.reloadData()
            return
        }
        searchTracks(query: query)
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackTableViewCell
        cell.configure(with: tracks[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let track = tracks[indexPath.row]
        navigateToDetail(track: track)
    }

    private func navigateToDetail(track: Track) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "TrackDetailViewController") as? TrackDetailViewController {
            detailVC.track = track
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
