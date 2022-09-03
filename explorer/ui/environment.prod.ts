import { IEnvironment } from './environment';

export const environmentProd: IEnvironment = {
    environments: [
        {
            name: 'Mainnet',
            url: 'http://localhost',
        },
    ],
    isLoggerEnabled: false,
};
