import { Executer } from './executer';

export interface AppInstaller {
  install(): Promise<void>;
}

export class BrewFormulaeAppInstaller implements AppInstaller {
  constructor(private appName: string, private executer: Executer, private tap?: string) {}

  async install() {
    if (this.tap) {
      await this.executer.run(`brew tap ${this.tap}`);
    }

    await this.executer.run(`brew install ${this.appName}`);
  }
}

export class BrewCaskAppInstaller implements AppInstaller {
  constructor(private appName: string, private executer: Executer) {}

  async install() {
    await this.executer.run(`brew install ${this.appName} --cask`);
  }
}

export class MasAppInstaller implements AppInstaller {
  constructor(private appId: string, private executer: Executer) {}

  async install() {
    await this.executer.run(`mas install ${this.appId}`);
  }
}
