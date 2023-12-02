import std.string;
import std.file;
import std.conv;
import std.stdio;
import std.algorithm;

struct CubeSet {
    int red, green, blue;
}

struct Game {
    int id;
    CubeSet[] sets;

    static Game parse(string s) {
        string[] gameAndSets = split(s, ":");
        Game g;
        g.id = gameAndSets[0].strip.split(" ")[1].to!int;
        foreach (string setStr; gameAndSets[1].strip.split(";")) {
            string[] components = setStr.split(",");
            CubeSet set;
            foreach (string component; components) {
                string[] countAndType = component.strip.split(" ");
                int count = countAndType[0].to!int;
                string type = countAndType[1];
                if (type == "red") set.red = count;
                else if (type == "green") set.green = count;
                else if (type == "blue") set.blue = count;
            }
            g.sets ~= set;
        }
        return g;
    }
}

void part1() {
    File("input.txt").byLineCopy().map!(Game.parse)
        .filter!((g) {
            foreach (CubeSet set; g.sets) {
                if (set.red > 12 || set.green > 13 || set.blue > 14) return false;
            }
            return true;
        })
        .map!(g => g.id)
        .sum.writeln;
}

void part2() {
    File("input.txt").byLineCopy().map!(Game.parse)
        .map!((g) {
            CubeSet minSet;
            foreach (CubeSet set; g.sets) {
                minSet.red = max(minSet.red, set.red);
                minSet.green = max(minSet.green, set.green);
                minSet.blue = max(minSet.blue, set.blue);
            }
            return minSet;
        })
        .map!(s => s.red * s.green * s.blue)
        .sum.writeln;
}

void main() {
    part1();
    part2();
}