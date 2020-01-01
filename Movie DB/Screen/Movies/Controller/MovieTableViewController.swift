//
//  MovieTableViewController.swift
//  Movie DB
//
//  Created by Ali Mert Özhayta on 25.12.2019.
//  Copyright © 2019 Ali Mert Özhayta. All rights reserved.
//

import UIKit

// MARK: - Movie TableView Controller

class MovieTableViewController: UITableViewController {
    
    var delegate: DetailsViewControllerDelegate?
    
    let tableViewCellIdentifier = "MovieTableCell"
    let tableViewHeaderNibName = "MovieTableViewHeaderView"
    let tableViewHeaderIdentifier = "MovieTableViewHeader"
    
    
    var topRatedMovies : [Movie]?  {
        didSet {
            setUI(movieType: .topRated)
        }
    }
    
    var popularMovies : [Movie]? {
           didSet {
               setUI(movieType: .popular)
           }
       }
    var nowPlayingMovies : [Movie]? {
           didSet {
               setUI(movieType: .nowPlaying)
           }
       }
    
    var isActive: Bool?
    
    // MARK: - View Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerNib = UINib(nibName: tableViewHeaderNibName, bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: tableViewHeaderIdentifier)
        
        self.requestMoviesFromAPI()
        isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isActive == false {
            self.requestMoviesFromAPI()
            isActive = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        isActive = false
    }
    
    // MARK: - Functions for View Load

    func requestMoviesFromAPI()  {
        API.getMoviesModel(movieType: .topRated, page: 1) { movies in
            print("\n\ncount of top rated movies that recevied::", movies.count)
            self.topRatedMovies = movies
        }
         
        API.getMoviesModel(movieType: .nowPlaying, page: 1) { movies in
            print("\n\ncount of now playing movies that recevied::", movies.count)
            self.nowPlayingMovies = movies
        }
        
        API.getMoviesModel(movieType: .popular, page: 1) { movies in
            print("\n\ncount of popular movies that recevied::", movies.count)
            self.popularMovies = movies
        }
    }
    

    func setUI(movieType: MovieTypes) {
        DispatchQueue.main.async {
            guard let cell = self.getMovieTableCellBy(movieType) else {return}
            cell.collectionView.reloadData()
        }
    }
    
    func getMovieTableCellBy(_ movieType: MovieTypes) -> MovieTableViewCell? {
        let cell = self.tableView.cellForRow(at: .init(row: 0, section: movieType.rawValue)) as? MovieTableViewCell ?? nil
        return cell
    }
    
}


// MARK: - UITableViewDelegate

extension MovieTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! MovieTableViewCell
        cell.collectionView.tag = indexPath.section
        cell.collectionView.reloadData()
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: tableViewHeaderIdentifier) as! MovieTableViewHeaderView
        guard let movieType = MovieTypes(rawValue: section) else {return headerView}
        headerView.categoryLabel.text = MovieTypes.toString(movieType)
        return headerView
    }
}

// MARK: - UICollectionViewDataSource

extension MovieTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
            case MovieTypes.topRated.rawValue:
                return topRatedMovies?.count ?? 0
           
           case MovieTypes.nowPlaying.rawValue:
               return nowPlayingMovies?.count ?? 0

           case MovieTypes.popular.rawValue:
               return popularMovies?.count ?? 0
        default:
            return 15
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieCollectionViewCell
        //print(collectionView.tag)
        let movies : [Movie]?
        
        switch collectionView.tag {
            case MovieTypes.topRated.rawValue:
                movies = topRatedMovies
            
            case MovieTypes.nowPlaying.rawValue:
                movies = nowPlayingMovies
            
            case MovieTypes.popular.rawValue:
                movies = popularMovies
                       
        default:
            return cell
        }
        
        guard let movie = movies?[indexPath.row] else {return cell}
        cell.setMovie(movie: movie)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MovieTableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Got clicked! collectionView.tag: \(collectionView.tag) - \(indexPath.row)")
        
        var movie: Movie? = nil
        
        switch collectionView.tag {
            case MovieTypes.topRated.rawValue:
                movie = topRatedMovies?[indexPath.row]
            case MovieTypes.nowPlaying.rawValue:
                movie = nowPlayingMovies?[indexPath.row]
            case MovieTypes.popular.rawValue:
                movie = popularMovies?[indexPath.row]
        default:
            return
        }
        
        guard let id = movie?.id else {return}
        
        API.getMovieDetails(id: id) { movieDetail in
            self.delegate?.didGetMovieDetails(movieDetails: movieDetail)
        }
        
        API.getCastAndCrew(id: id, fromMovie: true) { castAndCrewModel in
            self.delegate?.didGetCastAndCrew(castAndCrewModel)
        }
        
    }
}

// MARK: - Segue

extension MovieTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DetailsSegue" {
            print("\n\n\nsegue working")
            let vc : DetailsViewController = segue.destination as! DetailsViewController
            self.delegate = vc
        }
    }
}

