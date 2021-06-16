/**
 * @name Reflected cross-site scripting (work with ast)
 * @description Writing user input directly to an HTTP response allows for
 *              a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/zn/reflected-xss-work-with-ast
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */
 
import javascript
import DataFlow
import DataFlow::PathGraph
import semmle.javascript.security.dataflow.Xss

class PropWriteToRequestExpr extends DataFlow::Node {
    PropWriteToRequestExpr() {
        exists(HTTP::RequestExpr e, DataFlow::PropWrite pw |
            e.getParent*() = pw.getAstNode() and
            pw = this
        )
    }

    DataFlow::PropWrite getPropWrite() {
        result = this.(DataFlow::PropWrite)
    }

    // getPropWrite().getBase().toString() = "req.ctx"
    // getPropWrite().getPropertyName() = "requestId"
}

class PropReadFromRequestExpr extends DataFlow::Node {
    PropReadFromRequestExpr() {
        exists(HTTP::RequestExpr e, DataFlow::PropRead pw |
            e.getParent*() = pw.getAstNode() and
            pw = this
        )
    }

    // DataFlow::PropWrite getPropRead() {
    //     result = this.(DataFlow::PropRead)
    // }
}

class Config extends TaintTracking::Configuration {
    Config() { this = "TrainingExample1" }
  
    // step 1
    override predicate isSource(DataFlow::Node source) {
        // exists(My1 mock | mock = source)
        source instanceof HTTP::RequestInputAccess
    }
  
    override predicate isSink(DataFlow::Node sink) {
        // exists(DataFlow::Node mock | mock = sink)
        sink instanceof ReflectedXss::HttpResponseSink
    }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
        succ.(PropWriteToRequestExpr).getPropWrite().getWriteNode() = pred.getAstNode()
        or
        pred.(PropWriteToRequestExpr).toString() = succ.(PropReadFromRequestExpr).toString()
        or
        exists(VariableDeclarator vd, PropReadFromRequestExpr pr, PropWriteToRequestExpr pw, ASTNode n |
            vd.getInit() = pr.getAstNode() and // "req.ctx"
            pw.getPropWrite().getBase().toString() = pr.toString() and // "req.ctx".v === {v}="req.ctx"
            pw = pred and //
            vd.getBindingPattern().getAChild() = n and // match {a, b} to childs: a, b
            n.toString() = pw.getPropWrite().getPropertyName() and // check that req.ctx."v" === {"v"}=req.ctx
            succ.getAstNode() = n
        )
        or
        succ.(PropWriteToRequestExpr).getPropWrite().getRhs().(DataFlow::FunctionNode).getReturnNode() = pred
        or
        exists (InvokeNode n, PropReadFromRequestExpr e |
            n.getCalleeNode() = e and
            n = succ and
            e = pred
        )
    }

    override predicate isSanitizer(DataFlow::Node node) {
        super.isSanitizer(node) or
        node instanceof ReflectedXss::Sanitizer
    }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
        guard instanceof ReflectedXss::SanitizerGuard
    }
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Cross-site scripting vulnerability due to $@.",
    source.getNode(), "user-provided value"
