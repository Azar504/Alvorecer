#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>
#include <memory>
#include <chrono>
#include <thread>
#include <mutex>
#include <cstring>

#define MEMORY_ALERT "[MEMORY CRITICAL] "
const size_t MAX_ALLOC_SIZE = 1024 * 1024 * 1024; // 1GB

class SecureAllocator {
private:
    std::mutex alloc_mutex;
    std::unordered_map<void*, size_t> allocations;
    size_t total_allocated = 0;
    bool debug_mode;
    bool safety_checks;

    void log(const std::string& message) {
        if (debug_mode) {
            auto now = std::chrono::system_clock::now();
            auto time = std::chrono::system_clock::to_time_t(now);
            std::cout << "[" << std::ctime(&time) << "] " << message << std::endl;
        }
    }

    void validate_pointer(void* ptr, size_t size) {
        if (safety_checks) {
            if (ptr == nullptr) {
                log(MEMORY_ALERT "Null pointer detected");
                throw std::bad_alloc();
            }
            if (allocations.find(ptr) == allocations.end()) {
                log(MEMORY_ALERT "Invalid pointer access");
                throw std::runtime_error("Invalid pointer");
            }
            if (allocations[ptr] != size && size != 0) {
                log(MEMORY_ALERT "Size mismatch detected");
                throw std::runtime_error("Size mismatch");
            }
        }
    }

public:
    SecureAllocator(bool debug = false, bool safety = true) 
        : debug_mode(debug), safety_checks(safety) {}

    void* allocate(size_t size) {
        std::lock_guard<std::mutex> lock(alloc_mutex);

        if (size == 0) {
            log("Warning: Zero-size allocation requested");
            return nullptr;
        }

        if (size > MAX_ALLOC_SIZE) {
            log(MEMORY_ALERT "Oversized allocation attempted: " + std::to_string(size));
            throw std::bad_alloc();
        }

        if (total_allocated + size > MAX_ALLOC_SIZE * 3 / 4) {
            log(MEMORY_ALERT "Memory threshold reached, forcing collection");
            collect_garbage(true);
        }

        void* ptr = malloc(size);
        if (!ptr) {
            log(MEMORY_ALERT "Allocation failed for size: " + std::to_string(size));
            throw std::bad_alloc();
        }

        allocations[ptr] = size;
        total_allocated += size;
        log("Allocated " + std::to_string(size) + " bytes at " + std::to_string(reinterpret_cast<uintptr_t>(ptr)));

        return ptr;
    }

    void deallocate(void* ptr, size_t size = 0) {
        std::lock_guard<std::mutex> lock(alloc_mutex);
        validate_pointer(ptr, size);

        free(ptr);
        total_allocated -= allocations[ptr];
        allocations.erase(ptr);
        log("Deallocated " + std::to_string(size) + " bytes from " + std::to_string(reinterpret_cast<uintptr_t>(ptr)));
    }

    void* reallocate(void* ptr, size_t old_size, size_t new_size) {
        std::lock_guard<std::mutex> lock(alloc_mutex);
        validate_pointer(ptr, old_size);

        if (new_size > MAX_ALLOC_SIZE) {
            log(MEMORY_ALERT "Oversized reallocation attempted");
            throw std::bad_alloc();
        }

        void* new_ptr = realloc(ptr, new_size);
        if (!new_ptr) {
            log(MEMORY_ALERT "Reallocation failed");
            throw std::bad_alloc();
        }

        total_allocated -= allocations[ptr];
        allocations.erase(ptr);
        allocations[new_ptr] = new_size;
        total_allocated += new_size;

        log("Reallocated from " + std::to_string(old_size) + " to " + std::to_string(new_size) + " bytes");
        return new_ptr;
    }

    void collect_garbage(bool force = false) {
        std::lock_guard<std::mutex> lock(alloc_mutex);
        size_t before = total_allocated;

        if (force) {
            log("Forced garbage collection initiated");
            for (auto it = allocations.begin(); it != allocations.end(); ) {
                free(it->first);
                total_allocated -= it->second;
                it = allocations.erase(it);
            }
        } else {
            log("Incremental garbage collection started");
            size_t target = total_allocated / 2;
            while (total_allocated > target && !allocations.empty()) {
                auto it = allocations.begin();
                free(it->first);
                total_allocated -= it->second;
                allocations.erase(it);
            }
        }

        log("Garbage collection completed. Freed " + std::to_string(before - total_allocated) + " bytes");
    }

    ~SecureAllocator() {
        collect_garbage(true);
        if (total_allocated != 0) {
            std::cerr << MEMORY_ALERT << "Memory leak detected: " 
                     << total_allocated << " bytes remaining" << std::endl;
        }
    }
};

enum class GCLevel {
    LIGHT = 1,
    FORCE = 2,
    EXTREME = 3
};

class MemoryManager {
private:
    SecureAllocator allocator;
    GCLevel current_level;

public:
    MemoryManager(bool debug = false) 
        : allocator(debug, true), current_level(GCLevel::LIGHT) {}

    void set_level(GCLevel level) {
        current_level = level;
    }

    void* alloc(size_t size) {
        return allocator.allocate(size);
    }

    void free(void* ptr, size_t size = 0) {
        allocator.deallocate(ptr, size);
    }

    void collect() {
        switch (current_level) {
            case GCLevel::LIGHT:
                allocator.collect_garbage(false);
                break;
            case GCLevel::FORCE:
                allocator.collect_garbage(true);
                break;
            case GCLevel::EXTREME:
                for (int i = 0; i < 3; i++) {
                    allocator.collect_garbage(true);
                    std::this_thread::sleep_for(std::chrono::milliseconds(100));
                }
                break;
        }
    }

    void memory_report() const {
        std::cout << "Current memory usage: " 
                 << allocator.get_total_allocated() << " bytes" << std::endl;
    }
};

int main(int argc, char* argv[]) {
    try {
        MemoryManager mem(true);

        
        void* ptr1 = mem.alloc(1024);
        void* ptr2 = mem.alloc(2048);

        mem.set_level(GCLevel::FORCE);
        mem.collect();

        mem.free(ptr1, 1024);
        mem.free(ptr2, 2048);

        mem.set_level(GCLevel::EXTREME);
        mem.collect();

        mem.memory_report();

    } catch (const std::exception& e) {
        std::cerr << MEMORY_ALERT << "Exception: " << e.what() << std::endl;
        return 1;
    }

    return 0;
}
