from pathlib import Path


def datasource(file_path: Path) -> list[str]:

    with open(file_path) as file:
        return file.readlines()


def parser(content: list[str]):
    """
        icdf.cpp:48:17: missed: couldn't vectorize loop
        icdf.cpp:48:17: missed: not vectorized: control flow in loop.
        icdf.cpp:63:24: missed: statement clobbers memory: _46 = log (_45);
        icdf.cpp:63:15: missed: statement clobbers memory: z_96 = sqrt (_47);
        icdf.cpp:52:24: missed: statement clobbers memory: _4 = log (u_75);
        icdf.cpp:52:15: missed: statement clobbers memory: z_92 = sqrt (_5);

        <nome do arquivo>:<linha>:<coluna>: missed:<reason>:<information>

    """

    interest_files_names = [
        'HJM_Securities.cpp',
        'HJM_Swaption_Blocking.cpp',
        'HJM_SimPath_Forward_Blocking.cpp',
        'HJM.cpp',
        'CumNormalInv.cpp',

    ]

    for line in content:
        try:
            data = line.split(':')
            file_name = data[0]
            row = data[1]
            column = data[2]
            # reason = data[4]
            # print(data)
            if file_name in interest_files_names:
                print(f'{file_name},{row},{column}')
        except IndexError as e:
            # print(line)
            # return
            pass


def main():
    content = datasource(Path('build.txt'))
    csv_table = parser(content)
    pass


if __name__ == '__main__':
    main()
