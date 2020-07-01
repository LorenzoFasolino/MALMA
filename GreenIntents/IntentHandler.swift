//
//  IntentHandler.swift
//  GreenIntents
//
//  Created by Alessandro De Stefano on 04/06/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import Intents
import GreenCore

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
        
        let categories = StaticInit().categories
        
        for l in categories {
            if l.name.lowercased() == listName.spokenPhrase.lowercased() {
                return [INSpeakableString(spokenPhrase: l.name)]
            }
            if (l.name.lowercased().contains(listName.spokenPhrase.lowercased())) || listName.spokenPhrase.lowercased() == "tutti" {
                possibleLists.append(INSpeakableString(spokenPhrase: l.name))
            }
        }
        print("possible lists = \(possibleLists)")
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
