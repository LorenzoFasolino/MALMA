//
//  SearchTasksIntentHandler.swift
//  GreenIntents
//
//  Created by Alessandro De Stefano on 04/06/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import Foundation
import Intents

class SearchTasksIntentHandler: GreenIntentsHandler, INSearchForNotebookItemsIntentHandling {
    
    func resolveItemType(for intent: INSearchForNotebookItemsIntent,
                         with completion: @escaping (INNotebookItemTypeResolutionResult) -> Void) {

        completion(.success(with: .taskList))
    }
    
    func resolveTitle(for intent: INSearchForNotebookItemsIntent, with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
        guard let title = intent.title else {
            completion(.needsValue())
            return
        }

        let possibleLists = getPossibleLists(for: title)
        completeResolveListName(with: possibleLists, for: title, with: completion)
    }
    
    func handle(intent: INSearchForNotebookItemsIntent, completion: @escaping (INSearchForNotebookItemsIntentResponse) -> Void) {
        
    }
    
}
