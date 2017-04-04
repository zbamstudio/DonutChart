//
// Created by Emrah Ozer on 04/04/2017.
// Copyright (c) 2017 Emrah Ozer. All rights reserved.
//

import Foundation
import Darwin

extension Array
{
    func random() -> Element
    {
        return self[Int(arc4random_uniform(UInt32(self.count-1)))]
    }
}
