from cmath import inf
from matplotlib import pyplot
from pathlib import Path
from performances import Benchmark


def decorator_next_figure(pyplot: pyplot):
    fig = pyplot.figure(figsize=[10, 7], dpi=120, facecolor=[1, 1, 1])
    # fig.set_size_inches(32, 18)
    # pyplot.figure(len(pyplot.get_fignums())+1)


def decorator_custom_plot(pyplot: pyplot, x, y, y_label):
    pyplot.xlabel('threads')
    pyplot.ylabel(y_label)
    pyplot.xticks(x)
    pyplot.plot(x, y, '-o')

    pyplot.draw()


def decorator_clear_figures(pyplot: pyplot):
    for figure_number in pyplot.get_fignums():
        pyplot.figure(figure_number).clf()


def decorator_save_fig(pyplot: pyplot, file_name: Path):
    # figure = pyplot.gcf()
    # figure.set_size_inches(32, 18)
    pyplot.savefig(file_name)


def split_benchmark(benchmark: Benchmark) -> tuple[list[list[float]], list[list[float]], list[list[int]], list[str]]:
    speed_ups = []
    efficiencies = []
    times = []
    inputs = []
    for performance in benchmark.performances:
        speed_ups.append(performance.speed_ups)
        efficiencies.append(performance.efficiencies)
        times.append(performance.times)
        inputs.append(performance.input_title)

    return speed_ups, efficiencies, times, inputs


def decorator_custom_plot_2(pyplot: pyplot, xs, ys: list[list[float | int]], title: str, y_label: str,  legends: list[str]):
    for x, y in zip(xs, ys):
        x = list(range(1, len(y)+1))
        decorator_custom_plot(pyplot, x=x, y=y,
                              y_label=y_label)

    pyplot.title(title)
    pyplot.legend(legends)
    pyplot.grid(True)


def plot_benchmark(benchmark: Benchmark, output_dir: Path):

    if not output_dir.is_dir():
        output_dir.mkdir()

    title = benchmark.title
    speed_ups_list, efficiencies_list, times_list, input_names = split_benchmark(
        benchmark)
    threads = [list(range(1, len(y)+1)) for y in speed_ups_list]

    """
        dt/dthread,
        sabendo que  as threads variam de em 1, ou seja, 
        sempre a diferença será 1,
        dthread[i+1] - dthread[i] == 1 
    """
    def derivate(times: list[int]) -> list[float]:
        dt = [-inf]
        for i in range(1, len(times)):
            dt.append(times[i] - times[i-1])

        return dt
    dt = [derivate(times) for times in times_list]

    plot_data = {
        'speed_up': {
            'xs': threads,
            'ys': speed_ups_list,
            'y_label': 'speed up',
            'title': 'speed up',
            'legends': input_names,
            'file_name': output_dir.joinpath('speed_ups.svg')
        },
        'efficiency': {
            'xs': threads,
            'ys': efficiencies_list,
            'y_label': 'efficiency',
            'title': 'efficiency',
            'legends': input_names,
            'file_name': output_dir.joinpath('efficiencies.svg')
        },
        'times': {
            'xs': threads,
            'ys': times_list,
            'y_label': 'seconds',
            'title': 'time execution',
            'legends': input_names,
            'file_name': output_dir.joinpath('times.svg')
        },
        'dt': {
            'xs': threads,
            'ys': dt,
            'y_label': r'$\frac{dt}{dc}$',
            'title': 'derivada do tempo em relação a thread',
            'legends': input_names,
            'file_name': output_dir.joinpath('dt.svg')
        },

    }
    figure = pyplot.gcf()
    figure.set_dpi(120)
    figure.set_size_inches(10, 7)
    figure.set_facecolor((1,1,1))
    # figsize=[10, 7], dpi=120, facecolor=[1, 1, 1]
    for data in plot_data.values():
        decorator_custom_plot_2(pyplot,
                                xs=data['xs'],
                                ys=data['ys'],
                                title=f'{title} {data["title"]}',
                                y_label=data['y_label'],
                                legends=data['legends']
                                )
        decorator_save_fig(pyplot, data['file_name'])
        decorator_next_figure(pyplot)

    # pyplot.show()
    decorator_clear_figures(pyplot)


def histogram(performances: dict[str, dict[str, list[float]]], output_dir: Path):

    import numpy as np
    efficiencies_matrix = []
    for performance_dict in performances.values():
        efficiencies = performance_dict['efficiencies']
        efficiencies_matrix.append(efficiencies)

    efficiencies_matrix = np.array(efficiencies_matrix).T

    figure = pyplot.gcf()

    ax = figure.add_subplot(111)

    x_labels = list(range(1, efficiencies_matrix.shape[1]+1))
    y_labels = list(range(1, efficiencies_matrix.shape[0]+1))

    print(f'x_labels: {x_labels}')
    print(f'y_labels: {y_labels}')

    ax.matshow(efficiencies_matrix, aspect="auto")
    ax.set_yticks(list(range(len(y_labels))))
    ax.set_xticks(list(range(len(x_labels))))
    ax.set_xticklabels(x_labels)
    ax.set_yticklabels(y_labels)

    if not output_dir.is_dir():
        output_dir.mkdir()

    decorator_save_fig(pyplot, output_dir.joinpath('histogram.svg'))

    decorator_clear_figures(pyplot)
