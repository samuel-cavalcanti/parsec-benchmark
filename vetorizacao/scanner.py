def scanner(data):
    """
    nr_routines.c:15:9: missed: statement clobbers memory: __builtin_fwrite ("Numerical Recipes run-time error...\n", 1, 36, stderr.0_1);

    <file_name>:<int>:<int>: missed: <string>:<string>;
    <file_name> := <letra>(<letra> | <digito>)⁺.<end_files>
    <end_files> := c | cpp
    """

    current_pos = 0

    def end_files(string: str, current_pos: int) -> tuple[int, bool]:
        if string[current_pos] == 'c':
            if string[current_pos + 1] == ':':
                return current_pos + 1, True
            else:
                current_pos, False
        else:
            current_pos, False

    def file_name(string: str, current_pos: int) -> tuple[int, bool]:
        state = 0

        while True:

            if state == 0:
                if string[current_pos].isalpha():  # is_letra()
                    state = 1
                    current_pos += 1
                else:
                    return current_pos, False

            if state == 1:
                pass
