//
//  MovieBookmarkVO+Extension.swift
//  movie-core-data
//
//  Created by Sandi on 9/27/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import CoreData

extension BookMarkVO{
    static func saveBookMark(movieId: Int32, context: NSManagedObjectContext){
        let bookmarkMovieVO = BookMarkVO(context: context)
        bookmarkMovieVO.id = movieId
        
        do{
            try context.save()
        }catch{
            print("Failed to Save BookMark \(movieId)")
        }
    }
    
    static func deleteBookMark(movieId:Int, context:NSManagedObjectContext){
        let fetchRequest: NSFetchRequest<BookMarkVO> = BookMarkVO.fetchRequest()
        let delepredicate = NSPredicate(format: "id == %d", movieId)
        fetchRequest.predicate = delepredicate
        do{
            let data = try context.fetch(fetchRequest)
            try context.delete(data[0])
            try context.save()
        }catch{
            print("Failed to Delete BookMark \(movieId)")
        }
        
    }

    static func isMovieBookMark(movieId : Int) -> Bool {
        let fetchRequest : NSFetchRequest<BookMarkVO> = BookMarkVO.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", movieId)
        fetchRequest.predicate = predicate
        do {
            let data = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            if data.isEmpty{
                return false
            }
            return true
        } catch {
            print("\(error.localizedDescription)")
            return false
        }
        
    }
    
}

