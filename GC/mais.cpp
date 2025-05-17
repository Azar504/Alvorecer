#include <iostream>
#include <lua.hpp>

int main(int argc, char* argv[]) {
    if (argc < 2) return 1;

    lua_State* L = luaL_newstate();
    std::string cmd = argv[1];

    if (cmd == "force") {
        lua_gc(L, LUA_GCCOLLECT, 0);
        std::cout << "[C++] GC forced\n";
    } else if (cmd == "mem") {
        std::cout << "[C++] Memory: " << lua_gc(L, LUA_GCCOUNT, 0) << " KB\n";
    }

    lua_close(L);
    return 0;
}
