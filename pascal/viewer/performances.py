from dataclasses import dataclass


@dataclass
class Performance:
    speed_ups: list[float]
    efficiencies: list[float]
    times: list[int]
    input_title: str


@dataclass
class Benchmark:
    title: str
    performances: list[Performance]
