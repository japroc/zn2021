
export type Props = {
    /**
     * Prerendered html
     */
    html?: string;
    htmlAfter?: string;
    theme: string;
    /**
     * Page's stylesheets
     */
    stylesheets?: string[];
    /**
     * Page's scrips
     */
    scripts?: string[];
    /**
     * Script content before all <script>-tags
     */
    scriptBefore?: string;
    /**
     * Script content after all <script>-tags
     */
    scriptAfter?: string;
    /**
     * Any html-string to add in <head>-section
     */
    extraHead?: string;
    styleAfter?: string;
    //
    initialState?: any;
    cspNonce?: string;
    // HTML render time
    renderTime?: number;
    /**
     * DEPRECATED DO NOT USE
     */
    rumCounter: string;
};

export function renderPageHtml(props: Props): string {
    return (`<!doctype HTML>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
        <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7, IE=edge" />
        <meta name="format-detection" content="telephone=no" />
        <meta name="robots" content="noindex, nofollow" />
        <title>"Hello"</title>
        ${getScriptWithContent(props.rumCounter, undefined, props)}
    </head>
    <body >
        <span id="after-base"></span>
        <span id="blocked-message"></span>
    </body>
</html>`);
}

/**
 * Returns script tag
 */
function getScriptWithContent(content: string, src: string | void, props: Props) {
    const attrs = [
        // SRC attr
        src && ` src="${src}"`,
        // Nonce attr
        props.cspNonce && ` nonce="${props.cspNonce}"`,
    ]
        .filter((item) => !!item)
        .join('');

    return content || src ? `<script${attrs}>${content || ''}</script>` : '';
}