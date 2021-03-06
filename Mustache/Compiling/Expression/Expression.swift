// The MIT License
//
// Copyright (c) 2015 Gwendal Roué
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import Foundation

/**
The base abstract class for expressions that appear in tags: `name`,
`user.name`, `uppercase(user.name)`.

Expression conforms to Equatable so that the Compiler can check that section
tags have matching openings and closings: {{# person }}...{{/ person }} is OK
but {{# foo }}...{{/ bar }} is not.
*/
class Expression: Equatable {
    
    /**
    Has the visitor visit the expression.
    */
    func acceptExpressionVisitor(visitor: ExpressionVisitor) -> ExpressionVisitResult {
        fatalError("Subclass must override")
    }
    
    /**
    Polymorphic support for Equatable
    */
    func isEqual(expression: Expression) -> Bool {
        fatalError("Subclass must override")
    }
}

func ==(lhs: Expression, rhs: Expression) -> Bool {
    return lhs.isEqual(rhs)
}

/**
An expression visitor handles expressions.

ExpressionInvocation conforms to this protocol so that it can evaluate
expressions.
*/
protocol ExpressionVisitor {
    func visit(expression: FilteredExpression) -> ExpressionVisitResult
    func visit(expression: IdentifierExpression) -> ExpressionVisitResult
    func visit(expression: ImplicitIteratorExpression) -> ExpressionVisitResult
    func visit(expression: ScopedExpression) -> ExpressionVisitResult
}

enum ExpressionVisitResult {
    case Success
    case Error(NSError)
}

