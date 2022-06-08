import { IEnvironment } from './environment';

export const environmentProd: IEnvironment = {
    environments: [
        // {
        //   name: 'Testnet',
        //   url: 'https://testnet.ergoplatform.com',
        // },
        {
            name: 'Mainnet',
            url: 'http://localhost',
        },
    ],
    isLoggerEnabled: false,
};
