import { $ } from 'zx';
import { Executer } from './executer';

export class ZxShellExecuter implements Executer {
  async run(command: string) {
    await $`${command.split(' ')}`;
  }
}
