import { readFileSync } from 'fs';
import {
  AppInstaller,
  BrewCaskAppInstaller,
  BrewFormulaeAppInstaller,
  MasAppInstaller,
} from '../../domains/app-installer/app-installer.js';
import { Executer } from '../../domains/app-installer/executer.js';

export type CommandInfo = 'brew' | 'brewcask' | { command: 'mas'; id: string };
export type Platform = 'mac' | 'linux';

export type AppInfo = {
  name: string;
  mac?: CommandInfo;
  only?: Platform[];
  id?: string;
  tap?: string;
};

export const appInfoList: AppInfo[] = JSON.parse(
  readFileSync('./app-installer/data/app-info.json', 'utf-8')
) as AppInfo[];

export class AppInstallerRepository {
  constructor(private executer: Executer) {}

  list() {
    return appInfoList.map((appInfo) => AppInstallerFactory.create(appInfo, this.executer));
  }
}

export class AppInstallerFactory {
  static create(appInfo: AppInfo, executer: Executer): AppInstaller {
    if (appInfo.mac === 'brew') {
      return new BrewFormulaeAppInstaller(appInfo.id ?? appInfo.name, executer, appInfo.tap);
    }

    if (appInfo.mac === 'brewcask') {
      return new BrewCaskAppInstaller(appInfo.id ?? appInfo.name, executer);
    }

    if (appInfo.mac.command === 'mas') {
      return new MasAppInstaller(appInfo.mac.id, executer);
    }

    throw new Error('unknown install command');
  }
}
