//
//  ConfigurationContentTypeTests.swift
//  GRMustache
//
//  Created by Gwendal Roué on 13/11/2014.
//  Copyright (c) 2014 Gwendal Roué. All rights reserved.
//

import XCTest
import GRMustache

class ConfigurationContentTypeTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        
        Configuration.defaultConfiguration.contentType = .HTML
    }
    
    func testFactoryConfigurationHasHTMLContentTypeRegardlessOfDefaultConfiguration() {
        Configuration.defaultConfiguration.contentType = .HTML
        var configuration = Configuration()
        XCTAssertEqual(configuration.contentType, ContentType.HTML)
        
        Configuration.defaultConfiguration.contentType = .Text
        configuration = Configuration()
        XCTAssertEqual(configuration.contentType, ContentType.HTML)
    }
    
    func testDefaultConfigurationContentTypeHTMLHasTemplateRenderEscapedInput() {
        Configuration.defaultConfiguration.contentType = .HTML
        let template = Template(string: "{{.}}")!
        let rendering = template.render(Value("&"))!
        XCTAssertEqual(rendering, "&amp;")
    }

    func testDefaultConfigurationContentTypeTextLHasTemplateRenderUnescapedInput() {
        Configuration.defaultConfiguration.contentType = .Text
        let template = Template(string: "{{.}}")!
        let rendering = template.render(Value("&"))!
        XCTAssertEqual(rendering, "&")
    }
    
    func testDefaultConfigurationContentTypeHTMLHasTemplateRenderHTML() {
        // Templates tell if they render HTML or text via their
        // render(renderingInfo: RenderingInfo, contentType outContentType: ContentTypePointer, error outError: NSErrorPointer) -> String?
        // method.
        //
        // There is no public way to build a RenderingInfo.
        //
        // Thus we'll use a rendering object that will provide us with one:
        
        Configuration.defaultConfiguration.contentType = .HTML
        
        let testedTemplate = Template(string: "")!
        var templateContentType: ContentType = .HTML
        var templateContentTypeDefined = false
        let renderable = { (tag: Tag, renderingInfo: RenderingInfo, contentType: ContentTypePointer, error: NSErrorPointer) -> (String?) in
            let rendering = testedTemplate.render(renderingInfo, contentType: contentType, error:error)
            templateContentType = contentType.memory
            templateContentTypeDefined = true
            return nil
        }
        
        let template = Template(string: "{{.}}")!
        template.render(Value(renderable))
        XCTAssertTrue(templateContentTypeDefined)
        XCTAssertEqual(templateContentType, ContentType.HTML)
    }
    
    func testDefaultConfigurationContentTypeTextHasTemplateRenderText() {
        // Templates tell if they render HTML or text via their
        // render(renderingInfo: RenderingInfo, contentType outContentType: ContentTypePointer, error outError: NSErrorPointer) -> String?
        // method.
        //
        // There is no public way to build a RenderingInfo.
        //
        // Thus we'll use a rendering object that will provide us with one:
        
        Configuration.defaultConfiguration.contentType = .Text
        
        let testedTemplate = Template(string: "")!
        var templateContentType: ContentType = .HTML
        var templateContentTypeDefined = false
        let renderable = { (tag: Tag, renderingInfo: RenderingInfo, contentType: ContentTypePointer, error: NSErrorPointer) -> (String?) in
            let rendering = testedTemplate.render(renderingInfo, contentType: contentType, error:error)
            templateContentType = contentType.memory
            templateContentTypeDefined = true
            return nil
        }
        
        let template = Template(string: "{{.}}")!
        template.render(Value(renderable))
        XCTAssertTrue(templateContentTypeDefined)
        XCTAssertEqual(templateContentType, ContentType.Text)
    }
    
    func testDefaultConfigurationContentTypeHTMLHasSectionTagRenderHTML() {
        Configuration.defaultConfiguration.contentType = .HTML
        
        let testedTemplate = Template(string: "")!
        var templateContentType: ContentType = .HTML
        var templateContentTypeDefined = false
        let renderable = { (tag: Tag, renderingInfo: RenderingInfo, contentType: ContentTypePointer, error: NSErrorPointer) -> (String?) in
            let rendering = tag.renderContent(renderingInfo, contentType: contentType, error: error)
            templateContentType = contentType.memory
            templateContentTypeDefined = true
            return nil
        }
        
        let template = Template(string: "{{#.}}{{/.}}")!
        template.render(Value(renderable))
        XCTAssertTrue(templateContentTypeDefined)
        XCTAssertEqual(templateContentType, ContentType.HTML)
    }
    
    func testDefaultConfigurationContentTypeTextHasSectionTagRenderText() {
        Configuration.defaultConfiguration.contentType = .Text
        
        let testedTemplate = Template(string: "")!
        var templateContentType: ContentType = .HTML
        var templateContentTypeDefined = false
        let renderable = { (tag: Tag, renderingInfo: RenderingInfo, contentType: ContentTypePointer, error: NSErrorPointer) -> (String?) in
            let rendering = tag.renderContent(renderingInfo, contentType: contentType, error: error)
            templateContentType = contentType.memory
            templateContentTypeDefined = true
            return nil
        }
        
        let template = Template(string: "{{#.}}{{/.}}")!
        template.render(Value(renderable))
        XCTAssertTrue(templateContentTypeDefined)
        XCTAssertEqual(templateContentType, ContentType.Text)
    }
    
    func testDefaultConfigurationContentTypeHTMLHasVariableTagRenderHTML() {
        Configuration.defaultConfiguration.contentType = .HTML
        
        let testedTemplate = Template(string: "")!
        var templateContentType: ContentType = .HTML
        var templateContentTypeDefined = false
        let renderable = { (tag: Tag, renderingInfo: RenderingInfo, contentType: ContentTypePointer, error: NSErrorPointer) -> (String?) in
            let rendering = tag.renderContent(renderingInfo, contentType: contentType, error: error)
            templateContentType = contentType.memory
            templateContentTypeDefined = true
            return nil
        }
        
        let template = Template(string: "{{.}}")!
        template.render(Value(renderable))
        XCTAssertTrue(templateContentTypeDefined)
        XCTAssertEqual(templateContentType, ContentType.HTML)
    }
    
    func testDefaultConfigurationContentTypeTextHasVariableTagRenderText() {
        Configuration.defaultConfiguration.contentType = .Text
        
        let testedTemplate = Template(string: "")!
        var templateContentType: ContentType = .HTML
        var templateContentTypeDefined = false
        let renderable = { (tag: Tag, renderingInfo: RenderingInfo, contentType: ContentTypePointer, error: NSErrorPointer) -> (String?) in
            let rendering = tag.renderContent(renderingInfo, contentType: contentType, error: error)
            templateContentType = contentType.memory
            templateContentTypeDefined = true
            return nil
        }
        
        let template = Template(string: "{{.}}")!
        template.render(Value(renderable))
        XCTAssertTrue(templateContentTypeDefined)
        XCTAssertEqual(templateContentType, ContentType.Text)
    }
    
    func testPragmaContentTypeTextOverridesDefaultConfiguration() {
        Configuration.defaultConfiguration.contentType = .HTML
        let template = Template(string:"{{%CONTENT_TYPE:TEXT}}{{.}}")!
        let rendering = template.render(Value("&"))!
        XCTAssertEqual(rendering, "&")
    }
    
    func testPragmaContentTypeHTMLOverridesDefaultConfiguration() {
        Configuration.defaultConfiguration.contentType = .Text
        let template = Template(string:"{{%CONTENT_TYPE:HTML}}{{.}}")!
        let rendering = template.render(Value("&"))!
        XCTAssertEqual(rendering, "&amp;")
    }
    
    func testDefaultRepositoryConfigurationHasDefaultConfigurationContentType() {
        Configuration.defaultConfiguration.contentType = .HTML
        var repo = TemplateRepository()
        XCTAssertEqual(repo.configuration.contentType, ContentType.HTML)
        
        Configuration.defaultConfiguration.contentType = .Text
        repo = TemplateRepository()
        XCTAssertEqual(repo.configuration.contentType, ContentType.Text)
    }
    
    func testRepositoryConfigurationContentTypeHTMLHasTemplateRenderEscapedInputWhenSettingTheWholeConfiguration() {
        var configuration = Configuration()
        configuration.contentType = .HTML
        let repository = TemplateRepository()
        repository.configuration = configuration
        let template = repository.template(string: "{{.}}")!
        let rendering = template.render(Value("&"))!
        XCTAssertEqual(rendering, "&amp;")
    }
    
    func testRepositoryConfigurationContentTypeHTMLHasTemplateRenderEscapedInputWhenUpdatingRepositoryConfiguration() {
        let repository = TemplateRepository()
        repository.configuration.contentType = .HTML
        let template = repository.template(string: "{{.}}")!
        let rendering = template.render(Value("&"))!
        XCTAssertEqual(rendering, "&amp;")
    }
    
    func testRepositoryConfigurationContentTypeTextHasTemplateRenderUnescapedInputWhenSettingTheWholeConfiguration() {
        var configuration = Configuration()
        configuration.contentType = .Text
        let repository = TemplateRepository()
        repository.configuration = configuration
        let template = repository.template(string: "{{.}}")!
        let rendering = template.render(Value("&"))!
        XCTAssertEqual(rendering, "&")
    }
    
    func testRepositoryConfigurationContentTypeTextHasTemplateRenderUnescapedInputWhenUpdatingRepositoryConfiguration() {
        let repository = TemplateRepository()
        repository.configuration.contentType = .Text
        let template = repository.template(string: "{{.}}")!
        let rendering = template.render(Value("&"))!
        XCTAssertEqual(rendering, "&")
    }

    func testRepositoryConfigurationContentTypeTextOverridesDefaultConfigurationContentTypeHTMLWhenSettingTheWholeConfiguration() {
        Configuration.defaultConfiguration.contentType = .HTML
        var configuration = Configuration()
        configuration.contentType = .Text
        let repository = TemplateRepository()
        repository.configuration = configuration
        let template = repository.template(string: "{{.}}")!
        let rendering = template.render(Value("&"))!
        XCTAssertEqual(rendering, "&")
    }
    
    func testRepositoryConfigurationContentTypeTextOverridesDefaultConfigurationContentTypeHTMLWhenUpdatingRepositoryConfiguration() {
        Configuration.defaultConfiguration.contentType = .HTML
        let repository = TemplateRepository()
        repository.configuration.contentType = .Text
        let template = repository.template(string: "{{.}}")!
        let rendering = template.render(Value("&"))!
        XCTAssertEqual(rendering, "&")
    }
    
    func testRepositoryConfigurationContentTypeHTMLOverridesDefaultConfigurationContentTypeTextWhenSettingTheWholeConfiguration() {
        Configuration.defaultConfiguration.contentType = .Text
        var configuration = Configuration()
        configuration.contentType = .HTML
        let repository = TemplateRepository()
        repository.configuration = configuration
        let template = repository.template(string: "{{.}}")!
        let rendering = template.render(Value("&"))!
        XCTAssertEqual(rendering, "&amp;")
    }
    
    func testRepositoryConfigurationContentTypeHTMLOverridesDefaultConfigurationContentTypeTextWhenUpdatingRepositoryConfiguration() {
        Configuration.defaultConfiguration.contentType = .Text
        let repository = TemplateRepository()
        repository.configuration.contentType = .HTML
        let template = repository.template(string: "{{.}}")!
        let rendering = template.render(Value("&"))!
        XCTAssertEqual(rendering, "&amp;")
    }
    
    func testPragmaContentTypeTextOverridesRepositoryConfigurationContentTypeHTMLWhenSettingTheWholeConfiguration() {
        var configuration = Configuration()
        configuration.contentType = .HTML
        let repository = TemplateRepository()
        repository.configuration = configuration
        let template = repository.template(string: "{{%CONTENT_TYPE:TEXT}}{{.}}")!
        let rendering = template.render(Value("&"))!
        XCTAssertEqual(rendering, "&")
    }
    
    func testPragmaContentTypeTextOverridesRepositoryConfigurationContentTypeHTMLWhenUpdatingRepositoryConfiguration() {
        let repository = TemplateRepository()
        repository.configuration.contentType = .HTML
        let template = repository.template(string: "{{%CONTENT_TYPE:TEXT}}{{.}}")!
        let rendering = template.render(Value("&"))!
        XCTAssertEqual(rendering, "&")
    }
    
    func testPragmaContentTypeHTMLOverridesRepositoryConfigurationContentTypeTextWhenSettingTheWholeConfiguration() {
        var configuration = Configuration()
        configuration.contentType = .Text
        let repository = TemplateRepository()
        repository.configuration = configuration
        let template = repository.template(string: "{{%CONTENT_TYPE:HTML}}{{.}}")!
        let rendering = template.render(Value("&"))!
        XCTAssertEqual(rendering, "&amp;")
    }
    
    func testPragmaContentTypeHTMLOverridesRepositoryConfigurationContentTypeTextWhenUpdatingRepositoryConfiguration() {
        let repository = TemplateRepository()
        repository.configuration.contentType = .Text
        let template = repository.template(string: "{{%CONTENT_TYPE:HTML}}{{.}}")!
        let rendering = template.render(Value("&"))!
        XCTAssertEqual(rendering, "&amp;")
    }
    
    func testRepositoryConfigurationCanBeMutatedBeforeAnyTemplateHasBeenCompiled() {
        // TODO: import test from GRMustache
    }
    
    func testDefaultConfigurationCanBeMutatedBeforeAnyTemplateHasBeenCompiled() {
        // TODO: import test from GRMustache
    }
    
    func testRepositoryConfigurationCanNotBeMutatedAfterATemplateHasBeenCompiled() {
        // TODO: import test from GRMustache
    }
    
}