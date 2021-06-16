import { ExpressMiddlewareGetter } from './types';
import { renderPageHtml } from '../utils/renderPageHtml';

export const getReactRouterMiddleware: ExpressMiddlewareGetter = () => {

    
    return (req, res, next) => {
        res.status(200);
        res.end(
            renderPageHtml({
                cspNonce: "nonce",
                theme: "TariningTheme",
                // @ts-ignore
                rumCounter: req.getCounterScript(),
            }),
        );
        // next();
    }
}
