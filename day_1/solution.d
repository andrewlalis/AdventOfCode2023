module day_1.solution;

import std.file;
import std.string : splitLines;
import std.algorithm;
import std.stdio;
import std.uni : isNumber;

void part1() {
    readText("part_1_input.txt")
        .splitLines()
        .map!((line) {
            int a = -1, b = -1;
            for (size_t i = 0; i < line.length; i++) {
                if (a == -1 && isNumber(line[i])) a = line[i] - '0';
                if (b == -1 && isNumber(line[$-i-1])) b = line[$-i-1] - '0';
                if (a != -1 && b != -1) break;
            }
            return a * 10 + b;
        })
        .sum()
        .writeln();
}

void part2() {
    int findDigit(string s, size_t idx) {
        if (isNumber(s[idx])) return s[idx] - '0';
        const string[] words = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
        static foreach (size_t i, string word; words) {
            if (s.length - idx >= word.length && s[idx .. idx + word.length] == word) {
                return cast(int) i + 1;
            }
        }
        return -1;
    }

    readText("part_2_input.txt")
        .splitLines()
        .map!((line) {
            int a = -1, b = -1;
            for (size_t i = 0; i < line.length; i++) {
                int an = findDigit(line, i);
                int bn = findDigit(line, line.length-i-1);
                if (a == -1 && an != -1) a = an;
                if (b == -1 && bn != -1) b = bn;
                if (a != -1 && b != -1) break;
            }
            return a * 10 + b;
        })
        .sum()
        .writeln();
}

void main() {
    part1();
    part2();
}
