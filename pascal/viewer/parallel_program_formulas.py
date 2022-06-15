
def speed_up(t_serial, t_parallel):
    return t_serial/t_parallel


def efficiency(t_serial, t_parallel, cores):
    speed = speed_up(t_serial, t_parallel)
    return speed/cores
