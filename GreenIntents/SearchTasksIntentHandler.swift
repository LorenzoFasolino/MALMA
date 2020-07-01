//
//  SearchTasksIntentHandler.swift
//  GreenIntents
//
//  Created by Alessandro De Stefano on 04/06/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import Foundation
import Intents
import GreenCore

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
    
    func confirm(intent: INSearchForNotebookItemsIntent, completion: @escaping (INSearchForNotebookItemsIntentResponse) -> Void) {
        completion(INSearchForNotebookItemsIntentResponse(code: .success, userActivity: nil))
    }
    
    func handle(intent: INSearchForNotebookItemsIntent, completion: @escaping (INSearchForNotebookItemsIntentResponse) -> Void) {
        let categories = StaticInit().categories
        guard
            let title = intent.title,
            let list = categories.filter({ $0.name.lowercased() == title.spokenPhrase.lowercased()}).first
        else {
            completion(INSearchForNotebookItemsIntentResponse(code: .failure, userActivity: nil))
            return
        }

        let response = INSearchForNotebookItemsIntentResponse(code: .success, userActivity: nil)
        response.tasks = list.tasks.map {
            return INTask(title: INSpeakableString(spokenPhrase: $0.description),
                          status: $0.done ? INTaskStatus.completed : INTaskStatus.notCompleted,
                          taskType: INTaskType.notCompletable,
                          spatialEventTrigger: nil,
                          temporalEventTrigger: nil,
                          createdDateComponents: nil,
                          modifiedDateComponents: nil,
                          identifier: "\(list.name)\t\($0.description)")
        }
        completion(response)
    }
    
}
