from pathlib import Path
from typing import Optional


def datasource(file_path: Path) -> list[str]:

    with open(file_path) as file:
        return file.readlines()


def parser(content: list[str]) -> list[tuple[str, int, int, str]]:
    """
        icdf.cpp:48:17: missed: couldn't vectorize loop
        icdf.cpp:48:17: missed: not vectorized: control flow in loop.
        icdf.cpp:63:24: missed: statement clobbers memory: _46 = log (_45);
        icdf.cpp:63:15: missed: statement clobbers memory: z_96 = sqrt (_47);
        icdf.cpp:52:24: missed: statement clobbers memory: _4 = log (u_75);
        icdf.cpp:52:15: missed: statement clobbers memory: z_92 = sqrt (_5);

        <nome do arquivo>:<linha>:<coluna>: missed:<reason>:<information>

    """

    def parse_line(line: str) -> Optional[tuple[str, int, int, str]]:
        try:
            data = line.split(':')
            file_name = data[0]
            row = data[1]
            column = data[2]
            missed = data[4]
            if not missed[-1].isalnum():
                missed = missed[:-1]
            result_split = (file_name, int(row), int(column), missed)

            return result_split
        except IndexError as e:
            # print(f'index error in line: {line.encode()}')
            return None

    parsed_lines: list[tuple[str, int, int, str]] = list()
    for line in content:
        parsed_line = parse_line(line)
        if parsed_line:

            parsed_lines.append(parsed_line)

    return parsed_lines


def filter_table_by_file_name(row):
    interest_files_names = [
        'HJM_Securities.cpp',
        'HJM_Swaption_Blocking.cpp',
        'HJM_SimPath_Forward_Blocking.cpp',
        'HJM.cpp',
        'CumNormalInv.cpp',

    ]

    file_name = row[0]

    return file_name in interest_files_names

def sort_table(csv_table):

    table = dict()

    def fun(row):
        file_name = row[0]
        if table.get(file_name, None):
            table[file_name].append(row)
        else:
            table[file_name] = [row]

    [fun(row) for row in csv_table]

    sorted_table = list()

    for key in table:
        sorted_table += list(sorted(table[key], key=lambda row: row[1]))

    return sorted_table


def main():
    content = datasource(Path('build.txt'))
    csv_table = parser(content)
    filtered_table = list(filter(filter_table_by_file_name, csv_table))
    sorted_table = sort_table(filtered_table)


    [print_csv_mode(row) for row in sorted_table]


def print_csv_mode(row):
    csv_line = ''
    for col in row[:-1]:
        csv_line += f'{col},'
    csv_line += f'{row[-1]}'
    print(csv_line)

if __name__ == '__main__':
    main()
