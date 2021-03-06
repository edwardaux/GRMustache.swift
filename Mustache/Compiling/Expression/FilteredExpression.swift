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


/**
A filtered expression such as `uppercase(user.name)`.

A filtered expression has a single argument. Variadic filters found in templates
are implemented as a chain of partial applications: f(x,y) <=> f(x)(y)
*/
class FilteredExpression: Expression {
    let filterExpression: Expression
    let argumentExpression: Expression
    let partialApplication: Bool    // If true, this is a partial application
    
    init(filterExpression: Expression, argumentExpression: Expression, partialApplication: Bool) {
        self.filterExpression = filterExpression
        self.argumentExpression = argumentExpression
        self.partialApplication = partialApplication
    }
    
    override func acceptExpressionVisitor(visitor: ExpressionVisitor) -> ExpressionVisitResult {
        return visitor.visit(self)
    }
    
    override func isEqual(expression: Expression) -> Bool {
        if let expression = expression as? FilteredExpression {
            return (expression.filterExpression == filterExpression) && (expression.argumentExpression == argumentExpression)
        }
        return false
    }
}