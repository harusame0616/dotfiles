export interface Executer {
  run(command: string): Promise<void>;
}
