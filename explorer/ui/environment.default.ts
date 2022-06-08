import { IEnvironment } from './environment';

export const environmentDefault: IEnvironment = {
    alternativeLogo: true,
    // TODO: apiUrl is deprecated. Use apiBaseUrl instead.
    apiUrl: 'http://localhost/api/v0',
    apiBaseUrl: 'http://localhost',
    blockchain: {
        coinName: 'Erg',
    },
    defaultLocale: 'en',
    environments: [
        // {
        //   name: 'Testnet',
        //   url: 'http://localhost:3000',
        // },
        {
            name: 'Mainnet',
            url: 'http://localhost',
        },
    ],
    isLoggerEnabled: true,
};
