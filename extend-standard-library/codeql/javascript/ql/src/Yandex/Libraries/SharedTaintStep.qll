import javascript
import semmle.javascript.dataflow.TaintTracking

private predicate requestRead(DataFlow::SourceNode read, string path) {
  exists(HTTP::Servers::RequestSource req | read = AccessPath::getAReferenceTo(req.ref(), path))
}

private predicate requestWrite(DataFlow::Node rhs, string path) {
  exists(HTTP::Servers::RequestSource req | rhs = AccessPath::getAnAssignmentTo(req.ref(), path))
}

private predicate requestStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(string path |
    requestRead(succ, path) and
    requestWrite(pred, path)
  )
}

private predicate requestCallStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(DataFlow::FunctionNode func, DataFlow::CallNode call |
    requestStep(func, call.getCalleeNode()) and
    pred = func.getReturnNode() and
    succ = call
  )
}

private class MiddlwareRequestAttrReadWriteTaintStep extends TaintTracking::SharedTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    requestStep(pred, succ)
    or
    requestCallStep(pred, succ)
  }
}
