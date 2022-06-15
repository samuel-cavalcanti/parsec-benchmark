
import json
from pathlib import Path
from typing import Any
from execution import Execution


def load_json(file_path: str) -> dict:
    content = Path(file_path).read_text()

    json_data = json.loads(content)

    return dict(json_data)


def convert_input_type_to_parsec_type(input_type: str) -> str:
    match input_type:
        case '0':
            return 'simsmall'
        case '1':
            return 'simmedium'
        case '2':
            return 'simlarge'
        case '3':
            return 'native'


def json_to_execution(key: str, value: dict) -> Execution:
    start_time_in_ns = value['start_time']
    stop_time_in_ns = value['stop_time']
    number_of_cores, input_type, _ = key.split(';')
    parsec_input = convert_input_type_to_parsec_type(input_type)

    time = (stop_time_in_ns - start_time_in_ns)  # *1e-9

    return Execution(cores=int(number_of_cores), input_name=parsec_input, time_in_seconds=time)


def add(ordered_dict: dict, key: Any, value: Execution):
    if ordered_dict.get(key, None) is None:
        ordered_dict[key] = [value]
    else:
        ordered_dict[key].insert(0,value)


def parse(file_path: Path) -> tuple[dict[int, list[Execution]], dict[str, list[Execution]]]:

    json_content = load_json(file_path)

    executions_by_cores: dict[int, list[Execution]] = dict()
    executions_by_type: dict[str, list[Execution]] = dict()

    for key in json_content['data']:
        execution = json_to_execution(key, json_content['data'][key])

        add(executions_by_cores, execution.cores, execution)
        add(executions_by_type, execution.input_name, execution)

    

    return (executions_by_cores, executions_by_type)
