#ifndef PASCAL_ID_MAKER
#define PASCAL_ID_MAKER

#include <atomic>
#include <map>
#include <string>

class PascalIDMaker
{

private:
    std::atomic<int> _counter;
    std::map<std::string, int> _ids;
    static PascalIDMaker *_instance;

public:
    
    static PascalIDMaker *singleton()
    {

        if (_instance == nullptr)
        {
            _instance = new PascalIDMaker();
        }

        return _instance;
    }

    int get_id(const char *file_name, int line)
    {
        auto key = std::string(file_name) + std::to_string(line);

        if (_ids.find(key) != _ids.end())
        {
            return _ids[key];
        }
        else
        {
            auto new_id = _counter.load();
            _ids[key] = new_id;

            _counter.fetch_add(1);

            return new_id;
        }
    }
};

PascalIDMaker *PascalIDMaker::_instance = nullptr;
#endif // PASCAL_ID_MAKER

