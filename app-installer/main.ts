import { ZxShellExecuter } from './domains/app-installer/zx-shell-executer.js';
import { AppInstallerRepository } from './infra/repositories/app-installer-repository.js';
import { AppInstallerUsecase } from './usecases/app-installer-usecase.js';

(async () => {
  const usecase = new AppInstallerUsecase(new AppInstallerRepository(new ZxShellExecuter()));
  usecase.installPresetApps();
})();
