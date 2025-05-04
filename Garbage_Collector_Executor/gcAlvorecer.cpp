#include <iostream>
#include <fstream>
#include <filesystem>
#include <unordered_set>
#include <cstdlib>
#include <chrono>
#include <string>
#include <vector>
#include <algorithm>
#include <iomanip>
#include <ctime>
#include <thread>
#include <mutex>
#include <atomic>
#include <regex>
#include <sstream>

namespace fs = std::filesystem;

struct Config {
    std::string snapshot_file = "gc_snapshot.txt";
    std::string log_file = "gc_log.txt";
    std::string config_file = "gc_config.txt";
    std::string lua_cmd = "lua";
    std::string main_script = "main.lua";
    bool verbose = false;
    bool auto_clean = true;
    bool backup_files = true;
    std::string backup_dir = "gc_backup";
    std::vector<std::string> ignore_patterns;
    int backup_retention_days = 7;
    int log_retention_days = 30;
    std::chrono::seconds scan_interval{10};
};

class Logger {
private:
    std::mutex log_mutex;
    std::ofstream log_stream;
    bool verbose;
    
    std::string getTimestamp() {
        auto now = std::chrono::system_clock::now();
        auto now_time = std::chrono::system_clock::to_time_t(now);
        std::stringstream ss;
        ss << std::put_time(std::localtime(&now_time), "%Y-%m-%d %H:%M:%S");
        return ss.str();
    }
    
public:
    enum Level { DEBUG, INFO, WARNING, ERROR };
    
    Logger(const std::string& log_file, bool verbose_mode = false) : verbose(verbose_mode) {
        log_stream.open(log_file, std::ios::app);
    }
    
    ~Logger() {
        if (log_stream.is_open()) {
            log_stream.close();
        }
    }
    
    void log(Level level, const std::string& message) {
        std::lock_guard<std::mutex> lock(log_mutex);
        
        std::string level_str;
        switch (level) {
            case DEBUG: level_str = "DEBUG"; break;
            case INFO: level_str = "INFO"; break;
            case WARNING: level_str = "WARNING"; break;
            case ERROR: level_str = "ERROR"; break;
        }
        
        std::string log_message = getTimestamp() + " [" + level_str + "] " + message;
        
        if (log_stream.is_open()) {
            log_stream << log_message << std::endl;
        }
        
        if (verbose || level != DEBUG) {
            if (level == ERROR) {
                std::cerr << log_message << std::endl;
            } else {
                std::cout << log_message << std::endl;
            }
        }
    }
    
    void debug(const std::string& message) { log(DEBUG, message); }
    void info(const std::string& message) { log(INFO, message); }
    void warning(const std::string& message) { log(WARNING, message); }
    void error(const std::string& message) { log(ERROR, message); }
    
    void setVerbose(bool mode) { verbose = mode; }
    
    void cleanOldLogs(int days) {
    }
};

class BackupManager {
private:
    std::string backup_dir;
    Logger& logger;
    
public:
    BackupManager(const std::string& dir, Logger& log) : backup_dir(dir), logger(log) {
        ensureBackupDirExists();
    }
    
    void ensureBackupDirExists() {
        std::error_code ec;
        if (!fs::exists(backup_dir)) {
            fs::create_directories(backup_dir, ec);
            if (ec) {
                logger.error("Cannot create backup directory: " + ec.message());
            } else {
                logger.info("Backup directory created: " + backup_dir);
            }
        }
    }
    
    std::string createBackup(const std::string& filename) {
        std::error_code ec;
        auto now = std::chrono::system_clock::now();
        auto now_time = std::chrono::system_clock::to_time_t(now);
        
        std::stringstream ss;
        ss << std::put_time(std::localtime(&now_time), "%Y%m%d_%H%M%S");
        
        std::string backup_filename = backup_dir + "/" + ss.str() + "_" + filename;
        
        try {
            fs::copy_file(filename, backup_filename, fs::copy_options::overwrite_existing, ec);
            if (ec) {
                logger.error("Failed to backup " + filename + ": " + ec.message());
                return "";
            }
            logger.debug("Backup created: " + backup_filename);
            return backup_filename;
        } catch (const std::exception& e) {
            logger.error("Exception when backing up " + filename + ": " + e.what());
            return "";
        }
    }
    
    void cleanOldBackups(int days) {
        std::error_code ec;
        auto now = std::chrono::system_clock::now();
        
        try {
            for (const auto& entry : fs::directory_iterator(backup_dir)) {
                auto last_write_time = fs::last_write_time(entry.path(), ec);
                if (ec) continue;
                
                auto last_write = std::chrono::file_clock::to_sys(last_write_time);
                auto age = std::chrono::duration_cast<std::chrono::hours>(now - last_write).count() / 24;
                
                if (age > days) {
                    logger.debug("Removing old backup: " + entry.path().string());
                    fs::remove(entry.path(), ec);
                    if (ec) {
                        logger.warning("Could not remove old backup: " + ec.message());
                    }
                }
            }
        } catch (const std::exception& e) {
            logger.error("Error cleaning old backups: " + std::string(e.what()));
        }
    }
};

class GarbageCollector {
private:
    Config config;
    Logger logger;
    BackupManager backup_manager;
    std::atomic<bool> running{false};
    
    bool shouldIgnore(const std::string& filename) {
        if (filename == config.snapshot_file) return true;
        if (filename == config.log_file) return true;
        if (filename == config.config_file) return true;
        
        for (const auto& pattern : config.ignore_patterns) {
            std::regex re(pattern);
            if (std::regex_match(filename, re)) {
                return true;
            }
        }
        
        return false;
    }
    
public:
    GarbageCollector() : 
        logger(config.log_file, config.verbose),
        backup_manager(config.backup_dir, logger) {
        loadConfig();
    }
    
    void loadConfig() {
        std::ifstream config_file(config.config_file);
        if (!config_file.is_open()) {
            logger.info("Config file not found. Using default settings.");
            saveConfig();
            return;
        }
        
        std::string line;
        while (std::getline(config_file, line)) {
            if (line.empty() || line[0] == '#') continue;
            
            size_t pos = line.find('=');
            if (pos == std::string::npos) continue;
            
            std::string key = line.substr(0, pos);
            std::string value = line.substr(pos + 1);
            
            key.erase(0, key.find_first_not_of(" \t"));
            key.erase(key.find_last_not_of(" \t") + 1);
            value.erase(0, value.find_first_not_of(" \t"));
            value.erase(value.find_last_not_of(" \t") + 1);
            
            if (key == "snapshot_file") config.snapshot_file = value;
            else if (key == "log_file") config.log_file = value;
            else if (key == "lua_cmd") config.lua_cmd = value;
            else if (key == "main_script") config.main_script = value;
            else if (key == "verbose") config.verbose = (value == "true" || value == "1");
            else if (key == "auto_clean") config.auto_clean = (value == "true" || value == "1");
            else if (key == "backup_files") config.backup_files = (value == "true" || value == "1");
            else if (key == "backup_dir") config.backup_dir = value;
            else if (key == "backup_retention_days") config.backup_retention_days = std::stoi(value);
            else if (key == "log_retention_days") config.log_retention_days = std::stoi(value);
            else if (key == "scan_interval") config.scan_interval = std::chrono::seconds(std::stoi(value));
            else if (key == "ignore_pattern") config.ignore_patterns.push_back(value);
        }
        
        logger.setVerbose(config.verbose);
        logger.info("Settings loaded successfully.");
    }
    
    void saveConfig() {
        std::ofstream config_file(config.config_file);
        if (!config_file.is_open()) {
            logger.error("Could not save config file.");
            return;
        }
        
        config_file << "# Garbage Collector config file\n";
        config_file << "snapshot_file=" << config.snapshot_file << "\n";
        config_file << "log_file=" << config.log_file << "\n";
        config_file << "lua_cmd=" << config.lua_cmd << "\n";
        config_file << "main_script=" << config.main_script << "\n";
        config_file << "verbose=" << (config.verbose ? "true" : "false") << "\n";
        config_file << "auto_clean=" << (config.auto_clean ? "true" : "false") << "\n";
        config_file << "backup_files=" << (config.backup_files ? "true" : "false") << "\n";
        config_file << "backup_dir=" << config.backup_dir << "\n";
        config_file << "backup_retention_days=" << config.backup_retention_days << "\n";
        config_file << "log_retention_days=" << config.log_retention_days << "\n";
        config_file << "scan_interval=" << config.scan_interval.count() << "\n";
        
        for (const auto& pattern : config.ignore_patterns) {
            config_file << "ignore_pattern=" << pattern << "\n";
        }
        
        logger.info("Settings saved successfully.");
    }
    
    std::unordered_set<std::string> loadSnapshot() {
        std::unordered_set<std::string> files;
        std::ifstream in(config.snapshot_file);
        
        if (!in.is_open()) {
            logger.warning("Could not open snapshot file. Creating new empty snapshot.");
            return files;
        }
        
        std::string line;
        while (std::getline(in, line)) {
            if (!line.empty()) {
                files.insert(line);
            }
        }
        
        logger.debug("Snapshot loaded: " + std::to_string(files.size()) + " files");
        return files;
    }
    
    void saveSnapshot(const std::unordered_set<std::string>& files) {
        std::ofstream out(config.snapshot_file);
        
        if (!out.is_open()) {
            logger.error("Could not save snapshot file.");
            return;
        }
        
        for (const auto& file : files) {
            out << file << "\n";
        }
        
        logger.debug("Snapshot saved: " + std::to_string(files.size()) + " files");
    }
    
    std::unordered_set<std::string> scanCurrentDirectory() {
        std::unordered_set<std::string> files;
        std::error_code ec;
        
        try {
            for (const auto& entry : fs::directory_iterator(fs::current_path(), ec)) {
                if (ec) {
                    logger.error("Error iterating directory: " + ec.message());
                    continue;
                }
                
                if (entry.is_regular_file(ec) || entry.is_symlink(ec)) {
                    std::string filename = entry.path().filename().string();
                    files.insert(filename);
                }
            }
        } catch (const std::exception& e) {
            logger.error("Exception when scanning directory: " + std::string(e.what()));
        }
        
        logger.debug("Current scan: " + std::to_string(files.size()) + " files found");
        return files;
    }
    
    void cleanGarbage(const std::unordered_set<std::string>& before, 
                     const std::unordered_set<std::string>& after) {
        int removed = 0;
        int failed = 0;
        int backed_up = 0;
        
        for (const auto& file : after) {
            if (before.find(file) == before.end() && !shouldIgnore(file)) {
                logger.info("Removing temp file: " + file);
                
                if (config.backup_files) {
                    std::string backup_path = backup_manager.createBackup(file);
                    if (!backup_path.empty()) {
                        backed_up++;
                    }
                }
                
                std::error_code ec;
                fs::remove(file, ec);
                
                if (ec) {
                    logger.error("Error removing " + file + ": " + ec.message());
                    failed++;
                } else {
                    removed++;
                }
            }
        }
        
        logger.info("Cleanup complete: " + std::to_string(removed) + " file(s) removed, " + 
                  std::to_string(backed_up) + " backup(s) created, " + 
                  std::to_string(failed) + " failure(s)");
    }
    
    bool runLuaScript() {
        logger.info("Running " + config.main_script + "...");
        
        std::string cmd = config.lua_cmd + " " + config.main_script;
        int result = std::system(cmd.c_str());
        
        if (result != 0) {
            logger.error("Error running " + config.main_script + ". Exit code: " + std::to_string(result));
            return false;
        }
        
        logger.info(config.main_script + " ran successfully");
        return true;
    }
    
    void maintenance() {
        logger.debug("Running maintenance tasks...");
        
        logger.cleanOldLogs(config.log_retention_days);
        backup_manager.cleanOldBackups(config.backup_retention_days);
    }
    
    void startMonitoringMode() {
        logger.info("Starting monitor mode. Press Ctrl+C to exit.");
        running = true;
        
        auto initial_files = scanCurrentDirectory();
        saveSnapshot(initial_files);
        
        while (running) {
            runLuaScript();
            
            if (config.auto_clean) {
                auto before_files = loadSnapshot();
                auto after_files = scanCurrentDirectory();
                cleanGarbage(before_files, after_files);
                saveSnapshot(after_files);
            }
            
            maintenance();
            
            std::this_thread::sleep_for(config.scan_interval);
        }
    }
    
    void stopMonitoring() {
        running = false;
    }
    
    void showHelp() {
        std::cout << "Usage: gc [options]" << std::endl;
        std::cout << "Options:" << std::endl;
        std::cout << "  --help          Show this help" << std::endl;
        std::cout << "  --init          Init GC in current folder" << std::endl;
        std::cout << "  --clean         Clean files created after last run" << std::endl;
        std::cout << "  --run           Run Lua script and clean" << std::endl;
        std::cout << "  --monitor       Start monitoring mode" << std::endl;
        std::cout << "  --config        Show current settings" << std::endl;
        std::cout << "  --verbose       Enable detailed mode" << std::endl;
    }
    
    void showConfig() {
        std::cout << "=== Garbage Collector Settings ===" << std::endl;
        std::cout << "Snapshot file: " << config.snapshot_file << std::endl;
        std::cout << "Log file: " << config.log_file << std::endl;
        std::cout << "Lua command: " << config.lua_cmd << std::endl;
        std::cout << "Main script: " << config.main_script << std::endl;
        std::cout << "Verbose mode: " << (config.verbose ? "Yes" : "No") << std::endl;
        std::cout << "Auto clean: " << (config.auto_clean ? "Yes" : "No") << std::endl;
        std::cout << "Backup files: " << (config.backup_files ? "Yes" : "No") << std::endl;
        std::cout << "Backup folder: " << config.backup_dir << std::endl;
        std::cout << "Backup retention: " << config.backup_retention_days << " days" << std::endl;
        std::cout << "Log retention: " << config.log_retention_days << " days" << std::endl;
        std::cout << "Scan interval: " << config.scan_interval.count() << " seconds" << std::endl;
        
        std::cout << "Ignore patterns:" << std::endl;
        for (const auto& pattern : config.ignore_patterns) {
            std::cout << "  - " << pattern << std::endl;
        }
    }
    
    void initialize() {
        logger.info("Initializing Garbage Collector...");
        
        if (!fs::exists(config.config_file)) {
            saveConfig();
        }
        
        auto files = scanCurrentDirectory();
        saveSnapshot(files);
        
        logger.info("Init complete. Initial snapshot created with " + 
                  std::to_string(files.size()) + " files.");
    }
    
    void runClean() {
        if (!fs::exists(config.snapshot_file)) {
            logger.error("Snapshot file not found. Run --init first.");
            return;
        }
        
        logger.info("Running cleanup...");
        auto before = loadSnapshot();
        auto now = scanCurrentDirectory();
        cleanGarbage(before, now);
        saveSnapshot(now);
    }
    
    void runAndClean() {
        if (!fs::exists(config.snapshot_file)) {
            logger.error("Snapshot file not found. Run --init first.");
            return;
        }
        
        if (runLuaScript()) {
            auto before = loadSnapshot();
            auto now = scanCurrentDirectory();
            cleanGarbage(before, now);
            saveSnapshot(now);
            maintenance();
        }
    }
};

int main(int argc, char* argv[]) {
    GarbageCollector gc;
    
    if (argc == 1) {
        gc.showHelp();
        return 0;
    }
    
    for (int i = 1; i < argc; i++) {
        std::string arg = argv[i];
        
        if (arg == "--help") {
            gc.showHelp();
            return 0;
        } else if (arg == "--init") {
            gc.initialize();
        } else if (arg == "--clean") {
            gc.runClean();
        } else if (arg == "--run") {
            gc.runAndClean();
        } else if (arg == "--monitor") {
            gc.startMonitoringMode();
        } else if (arg == "--config") {
            gc.showConfig();
        } else if (arg == "--verbose") {
        } else {
            std::cerr << "Unknown option: " << arg << std::endl;
            gc.showHelp();
            return 1;
        }
    }
    
    return 0;
}