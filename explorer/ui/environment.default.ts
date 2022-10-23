import { IEnvironment } from './environment';

export const environmentDefault: IEnvironment = {
    alternativeLogo: false,
    // TODO: apiUrl is deprecated. Use apiBaseUrl instead.
    apiUrl: '_api_/api/v0',
    apiBaseUrl: '_api_',
    apiUrlV1: '_api_/api/v1',
    blockchain: {
        coinName: 'Erg',
    },
    defaultLocale: 'en',
    environments: [
        {
            name: '_name_',
            url: '_api_',
        },
    ],
    isLoggerEnabled: true,
};
