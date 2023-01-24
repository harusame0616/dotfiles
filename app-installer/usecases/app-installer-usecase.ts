import { Executer } from '../domains/app-installer/executer';
import { AppInstallerRepository } from '../infra/repositories/app-installer-repository';

export class AppInstallerUsease {
  constructor(private appInstallerRepository: AppInstallerRepository) {}

  async installPresetApps() {
    const appInstallers = this.appInstallerRepository.list();

    for (const appInstaller of appInstallers) {
      try {
        await appInstaller.install();
      } catch (err) {
        console.log('err:' + appInstaller);
      }
    }
  }
}
