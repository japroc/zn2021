/**
 * @name Reflected cross-site scripting (attrpath)
 * @description Writing user input directly to an HTTP response allows for
 *              a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/zn/reflected-xss-attrpath
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import DataFlow::PathGraph
import semmle.javascript.security.dataflow.ReflectedXssCustomizations::ReflectedXss

predicate requestRead(DataFlow::SourceNode read, string path) {
  exists(HTTP::Servers::RequestSource req | read = AccessPath::getAReferenceTo(req.ref(), path))
}

predicate requestWrite(DataFlow::Node rhs, string path) {
  exists(HTTP::Servers::RequestSource req | rhs = AccessPath::getAnAssignmentTo(req.ref(), path))
}

predicate requestStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(string path |
    requestRead(succ, path) and
    requestWrite(pred, path)
  )
}

predicate requestCallStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(DataFlow::FunctionNode func, DataFlow::CallNode call |
    requestStep(func, call.getCalleeNode()) and
    pred = func.getReturnNode() and
    succ = call
  )
}

/**
 * A taint-tracking configuration for reasoning about XSS.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ReflectedXss" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof SanitizerGuard
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    requestStep(pred, succ)
    or
    requestCallStep(pred, succ)
  }
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Cross-site scripting vulnerability due to $@.",
  source.getNode(), "user-provided value"
