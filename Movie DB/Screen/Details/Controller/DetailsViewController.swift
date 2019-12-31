//
//  DetailsViewController.swift
//  Movie DB
//
//  Created by Ali Mert Özhayta on 31.12.2019.
//  Copyright © 2019 Ali Mert Özhayta. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

        @IBOutlet weak var backGroundImageView: UIImageView!
        @IBOutlet weak var posterImageView: UIImageView!
        @IBOutlet weak var posterImageViewContainerView: UIView!
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var peopleWatchingLabel: UILabel!
        @IBOutlet weak var GenresLabel: UILabel!
        @IBOutlet weak var ratingLabel: UILabel!
        @IBOutlet weak var overviewLabel: UILabel!
        @IBOutlet weak var collectionView: UICollectionView!
        
        
        var tvDetailsModel: TVDetailsModel? {
            didSet {
                self.setUI()
            }
        }
        
    
       var movieDetailsModel: MovieDetailsModel? {
           didSet {
               self.setUI()
           }
       }
    
        var castAndCrewModel: CastAndCrewModel? {
            didSet {
                self.collectionView.reloadData()
            }
        }
        
        // MARK: - View Cycles

        override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.navigationBar.makeTransparent(true)
            
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            self.navigationController?.navigationBar.makeTransparent(false)
          }
    }

    // MARK: - DetailsViewController - View Setup

    extension DetailsViewController {
        func setUI() {

           // let c : TVDetailsModel? = nil
           // guard let a = self.tvDetailsModel ?? c else {return}
            
            
            DispatchQueue.main.async {
                // guard let details = self.tvDetailsModel else {return}

                self.titleLabel.text = self.tvDetailsModel?.name ?? self.movieDetailsModel?.title ?? ""

                self.posterImageView.backgroundColor = .clear
                self.posterImageView.corners(15)
                self.posterImageViewContainerView.addShadow(offset: CGSize(width: 5, height: 5), color: .darkGray, radius: 15, opacity: 0.9)
                self.posterImageViewContainerView.layer.shadowPath = UIBezierPath(roundedRect: self.posterImageView.bounds, cornerRadius: 15).cgPath
                
                let rating:Double =  self.tvDetailsModel?.rating ?? self.movieDetailsModel?.rating ?? 0
                
                self.ratingLabel.text = String(rating)
                self.selectStart(by: Int(rating / 2))
                self.overviewLabel.text = self.tvDetailsModel?.overview ?? self.movieDetailsModel?.overview ?? ""
                
                let popularity :Double = self.tvDetailsModel?.popularity ?? self.movieDetailsModel?.popularity ?? 0
                self.peopleWatchingLabel.text = String(popularity) + " People watching"
                
                let genres:[Genre] = self.tvDetailsModel?.genres ?? self.movieDetailsModel?.genres ?? []
                self.setGenresLable(genres)
                
                let posterPath = self.tvDetailsModel?.posterPath ?? self.movieDetailsModel?.posterPath ?? ""
                guard let posterURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else {return}
                self.posterImageView.af_setImage(withURL: posterURL)
            
                let backdrop = self.tvDetailsModel?.backdrop ?? self.movieDetailsModel?.backdrop ?? ""
                guard let backgroundURL = URL(string: "https://image.tmdb.org/t/p/w500/\(backdrop)") else {return}
                self.backGroundImageView.af_setImage(withURL: backgroundURL)
               }
           }
           
           func selectStart(by stars: Int) {
            if stars <= 0 {return}
               for tag in 1...stars {
                   let starButton = self.view.viewWithTag(tag) as? UIButton
                   starButton?.setBackgroundImage(UIImage(named: "icStarSelected") , for: .normal)
               }
           }
           
           func setGenresLable(_ genres: [Genre]) {
               var str = ""
               for genre in genres {
                   str += genre.name + ", "
               }
               str.removeLast(2)
               self.GenresLabel.text = str
           }
    }

    // MARK: - DetailsViewControllerDelegate

    extension DetailsViewController: DetailsViewControllerDelegate {
        func didGetCastAndCrew(_ castAndCrewModel: CastAndCrewModel) {
            print("\nTVDetailsViewController received Cast And Crew: ")
            self.castAndCrewModel = castAndCrewModel
        }
        
        
        func didGetTVDetails(tvDetails: TVDetailsModel) {
            print("\nTVDetailsViewController received: ")
            self.tvDetailsModel = tvDetails
        }
        
        func didGetMovieDetails(movieDetails: MovieDetailsModel) {
            print("\nMovieDetailsViewController received: ")
            movieDetailsModel = movieDetails
        }
    }


    // MARK: - UICollectionViewDataSource

    extension DetailsViewController : UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            var count = 0
            if let castCount = castAndCrewModel?.cast.count {
                count += castCount
            }
            if let crewCount = castAndCrewModel?.crew.count {
                count += crewCount
            }
            return count
        }
        
        
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as! CastCollectionViewCell

            guard let castAndCrewModel = castAndCrewModel else {return cell}
            if indexPath.row == 0, let crew = castAndCrewModel.crew.first {
                cell.setCrew(crew)
            }
            else {
                var index = indexPath.row
                if castAndCrewModel.crew.count == 1 && indexPath.row > 0 {
                    index -= 1 // if director exist reduce one
                }
                cell.setCast(castAndCrewModel.cast[index])
            }
            return cell
        }
      
    }
