from dataclasses import dataclass


@dataclass
class Execution:
    cores:int
    input_name:str
    time_in_seconds:int