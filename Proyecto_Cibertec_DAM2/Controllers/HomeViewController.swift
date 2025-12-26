//
//  HomeViewController.swift
//  Proyecto_Cibertec_DAM2
//
//  Created by user286645 on 12/26/25.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var tracks: [Track] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Charts"
        setupCollectionView()
        fetchCharts()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        // Configurar layout del collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        // Calcular tamaño de celda (2 columnas)
        let width = (view.bounds.width - 30) / 2
        layout.itemSize = CGSize(width: width, height: width + 60)

        collectionView.collectionViewLayout = layout
    }

    private func fetchCharts() {
        activityIndicator.startAnimating()

        NetworkManager.shared.getCharts { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()

                switch result {
                case .success(let tracks):
                    self?.tracks = tracks
                    self?.collectionView.reloadData()
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }

    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChartCell", for: indexPath) as! ChartCollectionViewCell
        cell.configure(with: tracks[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let track = tracks[indexPath.item]
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
