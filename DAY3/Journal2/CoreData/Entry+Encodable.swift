//
//  Entry+Encodable.swift
//  Journal2
//
//  Created by Carolyn Lea on 8/22/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import Foundation

extension Entry: Encodable
{
    enum CodingKeys: String, CodingKey
    {
        case title
        case bodyText
        case identifier
        case timestamp
        case mood
    }
}
