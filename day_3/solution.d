import std.stdio;
import std.file;
import std.string;
import std.algorithm;
import std.array;
import std.ascii : isDigit;
import std.conv;

struct Point {const int x, y;}

char getChar(ref char[][] array, int x, int y) {
    if (y >= 0 && y < array.length && x >= 0 && x < array[y].length) return array[y][x];
    return '.';
}

void part1() {
    char[][] schematic = File("input.txt").byLineCopy()
        .map!(line => cast(char[])line)
        .array();

    bool hasAdjacentSymbol(int x, int y, int length) {
        for (int i = y-1; i < y+2; i++) {
            for (int j = x-1; j < x+length+1; j++) {
                const char c = getChar(schematic, j, i);
                if (c != '.' && !isDigit(c)) return true;
            }
        }
        return false;
    }

    int sum = 0;
    for (int y = 0; y < schematic.length; y++) {
        for (int x = 0; x < schematic[y].length; x++) {
            if (isDigit(schematic[y][x])) {
                int length = 1;
                while (x + length < schematic[y].length && isDigit(schematic[y][x+length])) length++;
                if (hasAdjacentSymbol(x, y, length)) {
                    int n = schematic[y][x..x+length].to!int;
                    sum += n;
                }
                x += length;
            }
        }
    }
    writeln(sum);
}

void part2() {
    char[][] schematic = File("input.txt").byLineCopy()
        .map!(line => cast(char[])line)
        .array();

    Point[] findGears(int x, int y, int length) {
        Point[] gears;
        for (int i = y-1; i < y+2; i++) {
            for (int j = x-1; j < x+length+1; j++) {
                if (getChar(schematic, j, i) == '*') gears ~= Point(j, i);
            }
        }
        return gears;
    }

    int[][Point] gearNumbers;
    for (int y = 0; y < schematic.length; y++) {
        for (int x = 0; x < schematic[y].length; x++) {
            if (isDigit(schematic[y][x])) {
                int length = 1;
                while (x + length < schematic[y].length && isDigit(schematic[y][x+length])) length++;
                int n = schematic[y][x..x+length].to!int;
                Point[] gears = findGears(x, y, length);
                foreach (Point gear; gears) {
                    if (gear !in gearNumbers) gearNumbers[gear] = [];
                    gearNumbers[gear] ~= n;
                }
                x += length;
            }
        }
    }
    gearNumbers.values.map!(a => a.length == 2 ? a[0] * a[1] : 0).sum.writeln();
}

void main() {
    part1();
    part2();
}
