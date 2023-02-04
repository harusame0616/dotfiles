import * as fs from 'fs/promises';
import * as path from 'path';
import { fileURLToPath } from 'url';

type ConfigFileDto = {
  applicationName: string;
  sourcePath: string;
  destinationPath?: string;
};

const configFileDtoList = [
  {
    applicationName: 'tmux',
    sourcePath: '.tmux.conf',
  },
  {
    applicationName: 'vim',
    sourcePath: '.vimrc',
  },
  {
    applicationName: 'zsh',
    sourcePath: '.zshrc',
  },
];

class ConfigFile {
  static readonly SOURCE_BASE_PATH = path.resolve(path.dirname(fileURLToPath(import.meta.url)), 'files');
  static readonly DESTINATION_BASE_PATH = process.env.HOME;

  constructor(private configFileDto: ConfigFileDto) {}

  get sourcePath() {
    return path.resolve(ConfigFile.SOURCE_BASE_PATH, this.configFileDto.sourcePath);
  }

  get destinationPath() {
    return path.resolve(
      ConfigFile.DESTINATION_BASE_PATH,
      this.configFileDto.destinationPath ?? path.basename(this.configFileDto.sourcePath)
    );
  }

  get applicationName() {
    return this.configFileDto.applicationName;
  }
}

const main = async () => {
  console.log('■ Deploy config files');

  for (const configFile of configFileDtoList.map((configFileDto) => new ConfigFile(configFileDto))) {
    console.log(`- deploy ${configFile.applicationName} config file`);

    try {
      await fs.unlink(configFile.destinationPath);
    } catch (err: any) {
      // ファイルが存在パスが存在しない場合のエラー以外はエラーとして落とす
      if (err.code !== 'ENOENT') {
        throw err;
      }
    }
    await fs.link(configFile.sourcePath, configFile.destinationPath);
  }

  console.log('');
};

main();
