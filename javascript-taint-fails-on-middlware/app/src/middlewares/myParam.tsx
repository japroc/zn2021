import { ExpressMiddlewareGetter } from './types';

export const getMyParamMiddleware: ExpressMiddlewareGetter = () => {

    return (req, res, next) => {
        // @ts-ignore
        req.ctx.myParam = req.query.my_param || req.headers['my_param'] || '1234567890';
        next();
    }
}
