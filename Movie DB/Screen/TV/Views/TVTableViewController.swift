//
//  TVTableViewController.swift
//  Movie DB
//
//  Created by Ali Mert Özhayta on 28.12.2019.
//  Copyright © 2019 Ali Mert Özhayta. All rights reserved.
//

import UIKit

// MARK: - Protocol - TV Details View Controller Delegate

protocol TVDetailsViewControllerDelegate {
    func didGetTVDetails(tvDetails: TVDetailsModel)
    func didGetCastAndCrew(_ castAndCrewModel: CastAndCrewModel)
}

// MARK: - TV TableView Controller

class TVTableViewController: UITableViewController {

    let tableViewHeaderNibName = "MovieTableViewHeaderView"
    let tableViewHeaderIdentifier = "MovieTableViewHeader"
    
    var delegate: DetailsViewControllerDelegate?

    
    var topRatedTVs : [TVModel]?  {
        didSet {
            setUI(tvType: .topRated)
        }
    }
   
    var popularTVs : [TVModel]? {
        didSet {
            setUI(tvType: .popular)
        }
    }
    
    var isActive :Bool? = nil

    // MARK: - View Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        let headerNib = UINib(nibName: tableViewHeaderNibName, bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: tableViewHeaderIdentifier)
        
        isActive = true
        requestTVsFromAPI()
    }

    
    override func viewWillAppear(_ animated: Bool) {
           
           if isActive == false {
               self.requestTVsFromAPI()
               isActive = true
           }
       }

       override func viewWillDisappear(_ animated: Bool) {
           isActive = false
       }
       
    
    func requestTVsFromAPI()  {
        API.getTVModel(tvType: .topRated, page: 1) { TVModel in
            print("\n\nTop Rated TV Shows is received")
            self.topRatedTVs = TVModel
        }
        
        API.getTVModel(tvType: .popular, page: 1) { TVModel in
            print("\n\nPopular TV Shows is received")
            self.popularTVs = TVModel
        }
    }
    
    func setUI(tvType: TVTypes) {
        DispatchQueue.main.async {
            switch tvType {
                case .topRated:
                    let cell = self.tableView.cellForRow(at: .init(row: 0, section: tvType.rawValue)) as? TVTableViewCell1 ?? nil
                    cell?.collectionView.reloadData()
                case .popular:
                    self.tableView.reloadData()
            }

        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        return 15
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TVTableViewCell1", for: indexPath) as! TVTableViewCell1
             return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TVTableViewCell2", for: indexPath) as! TVTableViewCell2
            guard let model = popularTVs?[indexPath.row] else {return cell}
            cell.setTVcell(tvModel: model)
            return cell
        }
    }
        
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: tableViewHeaderIdentifier) as! MovieTableViewHeaderView
        guard let tvType = TVTypes(rawValue: section) else {return headerView}
        headerView.categoryLabel.text = TVTypes.toString(tvType)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var tvModel: TVModel? = nil
        tvModel = popularTVs?[indexPath.row]
        guard let id = tvModel?.id else {return}
        
        
        API.getTVDetails(id: id) { tvDetail in
            self.delegate?.didGetTVDetails(tvDetails: tvDetail)
        }
        
        API.getCastAndCrew(id: id, fromTV: true) { castAndCrewModel in
            self.delegate?.didGetCastAndCrew(castAndCrewModel)
        }
    }
    
}

extension TVTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topRatedTVs?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVCollectionViewCell", for: indexPath) as! TVCollectionViewCell
        guard let model = topRatedTVs?[indexPath.row] else {return cell}
        cell.setTVcell(tvModel: model)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TVTableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        var tvModel: TVModel? = nil
        tvModel = topRatedTVs?[indexPath.row]
        guard let id = tvModel?.id else {return}
        
        API.getTVDetails(id: id) { tvDetail in
            self.delegate?.didGetTVDetails(tvDetails: tvDetail)
        }
        
        API.getCastAndCrew(id: id, fromTV: true) { castAndCrewModel in
            self.delegate?.didGetCastAndCrew(castAndCrewModel)
        }
    }
}





// MARK: - Segue

extension TVTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DetailsSegue" {
            let vc : DetailsViewController = segue.destination as! DetailsViewController
            self.delegate = vc
        }
    }
}

