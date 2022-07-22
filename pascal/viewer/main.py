from pathlib import Path
import pascal_json_parser
import parallel_program_formulas
import plotter
from execution import Execution
from performances import Performance, Benchmark


def calculate_performance(executions: list[Execution], input_name: str) -> Performance:
    serial_execution = executions[0]
    assert serial_execution.cores == 1
    serial_time = serial_execution.time_in_seconds

    speed_ups = [1.0]
    efficiencies = [1.0]
    execution_times = [serial_time]

    for exec in executions[1:]:
        parallel_time = exec.time_in_seconds
        cores = exec.cores
        speed_up = parallel_program_formulas.speed_up(
            serial_time, parallel_time)
        efficiency = parallel_program_formulas.efficiency(
            serial_time, parallel_time, cores)

        speed_ups.append(speed_up)
        efficiencies.append(efficiency)
        execution_times.append(parallel_time)

    return Performance(speed_ups=speed_ups, efficiencies=efficiencies, times=execution_times, input_title=input_name)


def get_option_name(file_name: str) -> str:
    """get_option_name('swaptions-openmp.json') -> openmp"""
    return file_name.split('-')[1].split('.')[0]


def to_csv(executions_by_type: dict[str, list[Execution]], option: str) -> None:

    headers = ['algorithm', 'threads', 'type', 'time']

    algorithm = option

    lines = list()

    for executions in executions_by_type.values():
        
        line = [[algorithm, exe.cores, f'{exe.input_name}_{algorithm}', exe.time_in_seconds] for exe in executions ]
        lines+=line

    import csv

    time_file = Path('time.csv')
    if time_file.exists():
        with open(time_file, 'a') as csv_file:
            writer = csv.writer(csv_file, delimiter=',')
            writer.writerows(lines)
    else:
        with open(time_file, 'w') as csv_file:
            writer = csv.writer(csv_file, delimiter=',')
            writer.writerow(headers)
            writer.writerows(lines)


def visualizer(option:str, file_path: Path):
    _, executions_by_type = pascal_json_parser.parse(
        file_path)

   

    to_csv(executions_by_type, option)

    performances = [calculate_performance(v, k)
                    for k, v in executions_by_type.items()]

    benchmark = Benchmark(title=option, performances=performances)

    plotter.plot_benchmark(
        benchmark, output_dir=Path('results').joinpath(option))

    



def main():

    json_template = 'swaptions-{}.json'
    options = ['pthreads_serial_z','openmp_parallel_z','openmp','pthreads']

    for option in options:
        file_path = Path(json_template.format(option))
        visualizer(option, file_path)


if __name__ == '__main__':
    main()
