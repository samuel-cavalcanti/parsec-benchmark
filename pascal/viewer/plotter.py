from cmath import inf
from matplotlib import pyplot
from pathlib import Path


def decorator_next_figure(pyplot: pyplot):
    pyplot.figure(len(pyplot.get_fignums())+1)


def decorator_custom_plot(pyplot: pyplot, x, y, y_label):
    pyplot.xlabel('threads')
    pyplot.ylabel(y_label)
    pyplot.xticks(x)
    pyplot.plot(x, y, '-o')

    pyplot.draw()


def decorator_clear_figures(pyplot: pyplot):
    for figure_number in pyplot.get_fignums():
        pyplot.figure(figure_number).clf()


def plot_performance(title: str, performance_dict:  dict[str, list[float]]):

    speed_ups = performance_dict['speed_ups']

    efficiencies = performance_dict['efficiencies']

    x = list(range(1, len(speed_ups)+1))

    decorator_custom_plot(pyplot, x=x, y=speed_ups, y_label='speed up')
    pyplot.title(f'{title} speed up')

    decorator_next_figure(pyplot)

    decorator_custom_plot(pyplot, x=x, y=efficiencies, y_label='efficiency')
    pyplot.title(f'{title} efficiency')

    pyplot.show()


def decorator_save_fig(pyplot: pyplot, file_name: Path):
    figure = pyplot.gcf()
    figure.set_size_inches(32, 18)
    pyplot.savefig(file_name, bbox_inches='tight', dpi=100)


def plot_performances(performances: dict[str, dict[str, list[float]]], output_dir: Path):
    output_dir

    if not output_dir.is_dir():
        output_dir.mkdir()

    for performance_dict in performances.values():
        speed_ups = performance_dict['speed_ups']
        x = list(range(1, len(speed_ups)+1))
        decorator_custom_plot(pyplot, x=x, y=speed_ups,
                              y_label='speed up')

    pyplot.title('speed up')
    pyplot.legend(performances.keys())
    decorator_save_fig(pyplot, output_dir.joinpath('speed_ups.svg'))

    decorator_next_figure(pyplot)

    figure = pyplot.gcf()
    figure.set_size_inches(32, 18)

    for performance_dict in performances.values():
        efficiencies = performance_dict['efficiencies']
        x = list(range(1, len(efficiencies)+1))
        decorator_custom_plot(pyplot, x=x, y=efficiencies,
                              y_label='efficiency')

    pyplot.title('efficiency')
    pyplot.legend(performances.keys())
    decorator_save_fig(pyplot, output_dir.joinpath('efficiencies.svg'))

    decorator_next_figure(pyplot)

    figure = pyplot.gcf()
    figure.set_size_inches(32, 18)

    for performance_dict in performances.values():
        times = performance_dict['times']
        threads = list(range(1, len(times)+1))
        decorator_custom_plot(pyplot, x=threads, y=times,
                              y_label='seconds')

    pyplot.title('time execution')
    pyplot.legend(performances.keys())
    decorator_save_fig(pyplot, output_dir.joinpath('times.svg'))
    decorator_next_figure(pyplot)

    for performance_dict in performances.values():
        times = performance_dict['times']
        threads = list(range(1, len(times)+1))
        dt = [-inf]
        for i in range(1, len(times)):
            dt += [times[i] - times[i-1]]

        decorator_custom_plot(pyplot, x=threads, y=dt,
                              y_label='time per threads')

    pyplot.title('dt/dc')
    pyplot.legend(performances.keys())
    decorator_save_fig(pyplot, output_dir.joinpath('dt.svg'))


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