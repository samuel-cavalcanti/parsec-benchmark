from pathlib import Path
import pascal_json_parser
import parallel_program_formulas
import plotter
from execution import Execution


def calculate_performance(executions: list[Execution]) -> tuple[list[float], list[float]]:
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

    return speed_ups, efficiencies, execution_times


def visualizer(option,file_path:Path):
    _, executions_by_type = pascal_json_parser.parse(
        file_path)

    performances = dict()

    for key, value in executions_by_type.items():
        speed_ups, efficiencies, times = calculate_performance(value)
        performances[key] = {'speed_ups': speed_ups,
                             'efficiencies': efficiencies,
                             'times': times
                             }

    plotter.plot_performances(performances,output_dir=Path('results').joinpath(option))


def main():

    json_template = 'swaptions-{}.json'
    options = ['openmp', 'pthreads']

   
    for option in options:
        file_path = Path(json_template.format(option))
        visualizer(option,file_path)

  


if __name__ == '__main__':
    main()
