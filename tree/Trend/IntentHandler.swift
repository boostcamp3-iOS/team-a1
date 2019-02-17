//
//  IntentHandler.swift
//  Trend
//
//  Created by ParkSungJoon on 17/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    //MARK: Intent를 대신 처리해줄 Handler에게 넘기는 메소드입니다.
    override func handler(for intent: INIntent) -> Any {
        guard intent is TrendIntent else {
            fatalError("Unhandled intent type: \(intent)")
        }
        return TrendIntentHandler()
    }
}
