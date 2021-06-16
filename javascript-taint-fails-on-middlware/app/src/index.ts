
// https://developer.okta.com/blog/2018/11/15/node-express-typescript

import express from "express";
import { Response, NextFunction } from 'express';
import { Request, Router } from 'express';
import { getReactRouterMiddleware, getMyParamMiddleware, getCounterMiddleware } from './middlewares';

const app = express();
const port = 8080; // default port to listen


// Step 1. Initialize req.ctx
app.use(function (req, res, next) {
    // @ts-ignore
    req.ctx = {
        hello: "dude",
    };
    next();
})
// Step 2. Get request id
app.use(getMyParamMiddleware());
// Step 3. Get counter func
app.use(getCounterMiddleware())
// Step 4. Middleware that reflects untrusted data
app.use(getReactRouterMiddleware());


// define a route handler for the default home page
app.get( "/", ( req, res ) => {
    // @ts-ignore
    res.send( `Hello world2! ${ req.getCounterScript() }` );
} );

// start the Express server
app.listen( port, () => {
    // tslint:disable-next-line:no-console
    console.log( `server started at http://localhost:${ port }` );
} );
