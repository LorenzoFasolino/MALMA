//
//  IntentHandler.swift
//  GreenIntents
//
//  Created by Alessandro De Stefano on 04/06/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any? {
        switch intent {
        case is INSearchForNotebookItemsIntent:
            return SearchTasksIntentHandler()
        default:
            return nil
        }
    }
    
}

class GreenIntentsHandler: NSObject {
    
    public func getPossibleLists(for listName: INSpeakableString) -> [INSpeakableString] {
        var possibleLists = [INSpeakableString]()
        
        let categories = ["water", "energy", "garbage", "transport", "food"]
        
        for l in categories {
            if l.lowercased() == listName.spokenPhrase.lowercased() {
                return [INSpeakableString(spokenPhrase: l)]
            }
            if (l.lowercased().contains(listName.spokenPhrase.lowercased())) || listName.spokenPhrase.lowercased() == "all" {
                possibleLists.append(INSpeakableString(spokenPhrase: l))
            }
        }
        return possibleLists
    }

    public func completeResolveListName(with possibleLists: [INSpeakableString], for listName: INSpeakableString, with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
        switch possibleLists.count {
        case 0:
            completion(.unsupported())
        case 1:
            if possibleLists[0].spokenPhrase.lowercased() == listName.spokenPhrase.lowercased() {
                completion(.success(with: possibleLists[0]))
            } else {
                completion(.confirmationRequired(with: possibleLists[0]))
            }
        default:
            completion(.disambiguation(with: possibleLists))
        }
    }
    
}
