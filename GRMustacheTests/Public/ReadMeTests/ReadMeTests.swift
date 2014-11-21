//
//  ReadMeTests.swift
//  GRMustache
//
//  Created by Gwendal Roué on 21/11/2014.
//  Copyright (c) 2014 Gwendal Roué. All rights reserved.
//

import XCTest
import GRMustache

class ReadMeTests: XCTestCase {
    
    func testReadmeExample1() {
        let testBundle = NSBundle(forClass: self.dynamicType)
        let template = Template(named: "ReadMeExample1", bundle: testBundle)!
        let value = Value([
            "name": "Chris",
            "value": 10000.0,
            "taxed_value": 10000 - (10000 * 0.4),
            "in_ca": true
            ])
        let rendering = template.render(value)!
        XCTAssertEqual(rendering, "Hello Chris\nYou have just won 10000.0 dollars!\n\nWell, 6000.0 dollars, after taxes.\n")
    }
    
    func testReadmeExample2() {
        // Define the `pluralize` filter.
        //
        // {{# pluralize(count) }}...{{/ }} renders the plural form of the
        // section content if the `count` argument is greater than 1.
        
        let pluralizeFilter = { (count: Int?) -> (Value) in
            
            // Return a block that performs custom rendering:
            
            return Value({ (tag: Tag, renderingInfo: RenderingInfo, contentType: ContentTypePointer, error: NSErrorPointer) -> (String?) in
                
                // Pluralize the section inner content if needed:
                
                if count! > 1 {
                    return tag.innerTemplateString + "s"  // naive
                } else {
                    return tag.innerTemplateString
                }
            })
        }
        
        
        // Register the pluralize filter for all Mustache renderings:
        
        Configuration.defaultConfiguration.extendBaseContextWithValue(Value(pluralizeFilter), forKey: "pluralize")
        
        
        // I have 3 cats.
        
        let testBundle = NSBundle(forClass: self.dynamicType)
        let template = Template(named: "ReadMeExample2", bundle: testBundle)!
        let value = Value(["cats": ["Kitty", "Pussy", "Melba"]])
        let rendering = template.render(value)!
        XCTAssertEqual(rendering, "I have 3 cats.")
        
        Configuration.defaultConfiguration = Configuration()
    }
    
    func testReadmeExample3() {
        
        struct ReadmeExample3User: MustacheTraversable {
            let name: String
            
            func valueForMustacheIdentifier(identifier: String) -> Value? {
                switch identifier {
                case "name":
                    return Value(name)
                default:
                    return nil
                }
            }
        }
        
        let user = ReadmeExample3User(name: "Arthur")
        let rendering = Template(string:"Hello {{name}}!")!.render(Value(user))!
        XCTAssertEqual(rendering, "Hello Arthur!")
    }
    
}