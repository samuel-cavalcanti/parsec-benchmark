#include "../include/pascal_id_maker.hpp"
#include <cassert>
#include <iostream>

// Use (void) to silence unused warnings.
#define assertm(exp, msg) assert(((void)msg, exp))

int mini_loop()
{
    auto id_maker = PascalIDMaker::singleton();
    auto id = id_maker->get_id(__FILE__, __LINE__);

    return id;
}

int main(int argc, char const *argv[])
{

    auto id_maker = PascalIDMaker::singleton();

    auto id = id_maker->get_id(__FILE__, __LINE__);
    auto id_2 = id_maker->get_id(__FILE__, __LINE__);

    assertm(id == 0, "first id must be 0");

    assertm(id_2 == 1, "second id must be 1");

    auto id_3 = mini_loop();

    assertm(id_3 == 2, "third id must be 2");

    for (auto i = 0; i < 3; i++)
    {
        auto result_id = mini_loop();
        assertm(result_id == id_3, "result_id must be the same of third id ");
    }

    std::cout << __FILE__ << " Pass in tests" << std::endl;

    return 0;
}
