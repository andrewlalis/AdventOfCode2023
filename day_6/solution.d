import std.stdio;
import std.array;
import std.algorithm;
import std.string;
import std.conv;
import std.math;

struct Race {
    long time, dist;
}

Race[] parseRaces(string filename) {
    string[] lines = File(filename).byLineCopy.array;
    long[] times = lines[0].split(":")[1].strip.split.map!(to!long).array;
    long[] distances = lines[1].split(":")[1].strip.split.map!(to!long).array;
    Race[] result = new Race[](times.length);
    foreach (size_t i, long time; times) {
        result[i] = Race(time, distances[i]);
    }
    return result;
}

Race parseKernedRace(string filename) {
    string[] lines = File(filename).byLineCopy.array;
    long time = lines[0].split(":")[1].strip.split.join.to!long;
    long dist = lines[1].split(":")[1].strip.split.join.to!long;
    return Race(time, dist);
}

long computeSolutions(in Race r) {
    double D = r.time * r.time - 4 * r.dist;
    double t1 = (-r.time + sqrt(D)) / -2;
    double t2 = (-r.time - sqrt(D)) / -2;
    long minWinningTime = cast(long) (ceil(t1) == t1 ? t1 + 1 : ceil(t1));
    long maxWinningTime = cast(long) (floor(t2) == t2 ? t2 - 1 : floor(t2));
    return maxWinningTime - minWinningTime + 1;
}

void part1() {
    parseRaces("input.txt").map!computeSolutions.fold!((a, b) => a * b).writeln;

}

void part2() {
    parseKernedRace("input.txt").computeSolutions.writeln;
}

void main() {
    part1();
    part2();
}