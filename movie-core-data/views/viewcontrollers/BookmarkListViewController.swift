//
//  BookmarkListViewController.swift
//  movie-core-data
//
//  Created by Sandi on 9/27/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import CoreData

class BookmarkListViewController: UIViewController {

    
    @IBOutlet weak var bookmarkListCollectionView: UICollectionView!
    
    var bookmarksResultController: NSFetchedResultsController<BookMarkVO>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBookMarksMovieListFetchRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Bookmarks List"
    }
    
    private func initView(){
        bookmarkListCollectionView.delegate = self
        bookmarkListCollectionView.dataSource = self
        bookmarkListCollectionView.backgroundColor = Theme.background
    }
    
    fileprivate func initBookMarksMovieListFetchRequest() {
        //FetchRequest
        let fetchRequest : NSFetchRequest<BookMarkVO> = BookMarkVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        bookmarksResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: "movies")
        bookmarksResultController.delegate = self
        
        do {
            try bookmarksResultController.performFetch()
            //            if let objects = bookmarksResultController.fetchedObjects, objects.count == 0 {
            //            }
        } catch {
            Dialog.showAlert(viewController: self, title: "Error", message: "Failed to fetch data from database")
        }
    }
}

extension BookmarkListViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return bookmarksResultController.sections?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarksResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = bookmarksResultController.object(at: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell.identifier, for: indexPath) as? BookmarkCollectionViewCell else {
            return UICollectionViewCell()
        }
        let getMovie = MovieVO.getMovieById(movieId: Int(movie.id))
        cell.data = getMovie
        return cell
    }
}
extension BookmarkListViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieDetailsViewController = segue.destination as? MovieDetailsViewController {
            if let indexPaths = bookmarkListCollectionView.indexPathsForSelectedItems, indexPaths.count > 0 {
                let selectedIndexPath = indexPaths[0]
                let movieId = Int(bookmarksResultController.object(at: selectedIndexPath).id)
                let movie = MovieVO.getMovieById(movieId: movieId)
                movieDetailsViewController.movieId = movieId
                self.navigationItem.title = movie?.original_title ?? ""
            }
            
        }
    }
    
}
extension BookmarkListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        bookmarkListCollectionView.reloadData()
    }
}
extension BookmarkListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10;
        return CGSize(width: width, height: width * 1.45)
    }
}
