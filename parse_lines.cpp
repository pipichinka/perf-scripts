#include <iostream>
#include <fstream>
#include <string>
#include <unordered_map>
#include <vector>
#include <algorithm>


int main(int argc, char** argv){
    if (argc == 1){
        std::cerr << "no input parametr\n";
        return 0;
    }

    std::fstream file(argv[1]);
    if (!file){
        std::cerr << "can't open file\n";
        return 0;
    }
    std::unordered_map<std::string, int> code_lines_map;
    while(!file.eof()){
        char line[1024];
        file.getline(line, 1023, '\n');
        if (line[0] == '#'){
            continue;
        }
        std::string func_line(line);
        //std::cout << func_line;
        if (func_line.compare(0, sizeof("postgres") - 1, "postgres") != 0 ){
            continue;
        }
        file.getline(line, 1023, '\n');
        func_line = line;
        size_t space_index = func_line.find_last_of(' ', func_line.length());
        //std::cout << func_line << " " << space_index << std::endl;
        if (space_index == std::string::npos){
            continue;
        }

        if (func_line.compare(space_index - sizeof("base_yyparse") + 1, sizeof("base_yyparse") - 1, "base_yyparse")){
            continue;
        }

        file.getline(line, 1023, '\n');
        code_lines_map[line] += 1;
        //std::cout << line << std::endl;
    }
    std::vector<std::unordered_map<std::string,int>::value_type*> code_lines;
    for (auto it = code_lines_map.begin(); it != code_lines_map.end(); ++it){
        code_lines.push_back(it._M_cur->_M_storage._M_ptr());
    }
    struct
    {
        bool operator()(std::pair<const std::string, int>* a, std::pair< const std::string, int>* b) const { return a->second > b->second; }
    }
    customLess;
    std::sort(code_lines.begin(), code_lines.end(), customLess);
    for (size_t i = 0; i < code_lines.size(); i++){
        std::cout << code_lines[i]->first << "  " << code_lines[i]->second << "\n";
    }
    return 0;
}