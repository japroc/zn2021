This example shows example when javascript taint tracking fails on data flow through request context

Folder `app` contains and example application.
* Setup env instruction: https://developer.okta.com/blog/2018/11/15/node-express-typescript. 
* Run the app: `npm run start`
* Exploit: `http://localhost:8080/?request_id="</script><script>alert(1)</script>`

Folder `codeql` contains codeql queries and snippets to workaround that drawback.
* `ReflectedXSSWorkWithAST.ql` - first version of custom query. It's hard to read and write, because it's based solely on work with AST.
* `ReflectedXSSAttrPath.ql` - better version of the same query. It uses standart library class `AttrPath` to simplify the query.
* `SharedTaintStep.qll` - codeql library that may be used to extend ALL queries. Just import it in `Customizations.qll` file.
