module day_1.solution;

import std.file;
import std.string : splitLines;
import std.algorithm;
import std.stdio;
import std.uni : isNumber;
import std.functional;

/// Parses the first and last digits, using a function F to determine if and
/// what digit is at a string at a particular index. F should return -1 if no
/// digit exists.
int parseDigits(int delegate(string, size_t) F)(string s) {
    int a = -1, b = -1;
    for (size_t i = 0; i < s.length; i++) {
        int an = F(s, i);
        int bn = F(s, s.length-i-1);
        if (a == -1 && an != -1) a = an;
        if (b == -1 && bn != -1) b = bn;
        if (a != -1 && b != -1) break;
    }
    return a * 10 + b;
}

void part1() {
    readText("part_1_input.txt").splitLines()
        .map!(line => parseDigits!((s, i) => isNumber(s[i]) ? s[i] - '0' : -1)(line))
        .sum().writeln();
}

void part2() {
    int findDigit(string s, size_t idx) {
        if (isNumber(s[idx])) return s[idx] - '0';
        const string[] words = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
        static foreach (size_t i, string word; words) {
            if (s.length - idx >= word.length && s[idx .. idx + word.length] == word) return cast(int) i + 1;
        }
        return -1;
    }

    readText("part_2_input.txt").splitLines()
        .map!(line => parseDigits!((s, i) => findDigit(s, i))(line))
        .sum().writeln();
}

void main() {
    part1();
    part2();
}
