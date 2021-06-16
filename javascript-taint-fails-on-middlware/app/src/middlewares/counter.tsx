import { ExpressMiddlewareGetter } from './types';

type Params = {
    version: string;
    tld: string;
    myParam: string;
    env: string;
    platform: string;
    location: string;
};

export const getCounterScript = (params: Params): string => {
    const { myParam, env, platform, version, tld } = params;

    const counterScript = [
        "console.log('block1');",
        "console.log('block2');",
        [
            'Counter.init({',
            `reqid: "${myParam}"`,
            '}, {',
            '"-project": "TrainingProject",',
            `env: "${env}",`,
            `"-version": "${version}",`,
            `platform: "${platform}"`,
            '});',
        ].join(''),
        "console.log('block4');"
    ];

    const script = env === 'development' ? '' : counterScript.join('');

    return script;
};

export const getCounterMiddleware: ExpressMiddlewareGetter = () => {

    return (req, res, next) => {
        // @ts-ignore
        const { tld, myParam, location } = req.ctx;
        const params = {
            tld,
            myParam,
            env: "production",
            platform: "desktop",
            location
        };

        // @ts-ignore
        req.getCounterScript = () => getCounterScript(params);

        next();
    }
}
