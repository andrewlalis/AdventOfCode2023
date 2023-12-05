import std.file;
import std.string;
import std.conv;
import std.algorithm;
import std.stdio;
import std.array;
import std.format;
import std.ascii;

bool rangesOverlap(long startA, long endA, long startB, long endB) {
    return (startA <= endB && startB <= endA) || (startB <= endA && startA <= endB);
}

struct Mapping {
    long destinationRangeStart, sourceRangeStart, length;

    long sourceRangeEnd() const {
        return sourceRangeStart + length - 1;
    }

    long destinationRangeEnd() const {
        return destinationRangeStart + length - 1;
    }

    long diff() const {
        return destinationRangeStart - sourceRangeStart;
    }

    bool containsSourceValue(long value) {
        return value >= sourceRangeStart && value <= sourceRangeEnd;
    }

    bool containsDestinationValue(long value) {
        return value >= destinationRangeStart && value <= destinationRangeEnd;
    }

    long map(long value) {
        if (containsSourceValue(value)) return value + diff;
        return value;
    }

    long unmap(long value) {
        if (containsDestinationValue(value)) return value - diff;
        return value;
    }

    bool destinationOverlapsWithOtherSource(Mapping other) {
        return rangesOverlap(destinationRangeStart, destinationRangeEnd, other.sourceRangeStart, other.sourceRangeEnd);
    }

    /// Failed attempt to optimize this solution.
    Mapping[] combine(Mapping second) {
        if (!destinationOverlapsWithOtherSource(second)) return [this, second];
        long overlapStart = destinationRangeStart >= second.sourceRangeStart
            ? destinationRangeStart
            : second.sourceRangeStart;
        long overlapEnd = destinationRangeEnd <= second.sourceRangeEnd
            ? destinationRangeEnd
            : second.sourceRangeEnd;
        writefln!"Combining mapping %s and %s. Overlap: [%d, %d]"(this, second, overlapStart, overlapEnd);
        Mapping[] combination;
        return combination;
    }
}

struct Almanac {
    long[] seeds;
    Mapping[][] mappings;
}

Almanac parseAlmanac(string filename) {
    string[] lines = File(filename).byLineCopy().array;
    Almanac a;
    a.seeds = lines[0].split(":")[1].split.map!(to!long).array;
    Mapping[] currentMapping;
    for (int i = 2; i < lines.length; i++) {
        if (lines[i].length == 0 || !isDigit(lines[i][0])) {
            if (currentMapping.length > 0) a.mappings ~= currentMapping;
            currentMapping = [];
        } else {
            Mapping m;
            formattedRead(lines[i], "%d %d %d", m.destinationRangeStart, m.sourceRangeStart, m.length);
            currentMapping ~= m;
        }
    }
    if (currentMapping.length > 0) a.mappings ~= currentMapping;
    return a;
}

/// A failed attempt to optimize this!
Mapping[] combineMappingSets(Mapping[] firstSet, Mapping[] secondSet) {
    Mapping[] result;

    foreach (Mapping first; firstSet) {
        foreach (Mapping second; secondSet) {
            if (first.destinationOverlapsWithOtherSource(second)) {

            }
        }
    }

    return result;
}

void part1() {
    Almanac a = parseAlmanac("input.txt");
    long minValue = 1_000_000_000;
    foreach (long seed; a.seeds) {
        long value = seed;
        foreach (Mapping[] mappingSet; a.mappings) {
            bool mapped = false;
            foreach (Mapping mapping; mappingSet) {
                if (mapping.containsSourceValue(value)) {
                    value = mapping.map(value);
                    mapped = true;
                    break;
                }
            }
        }
        minValue = min(minValue, value);
    }
    writeln(minValue);
}

void part2() {
    import std.parallelism;
    Almanac a = parseAlmanac("input.txt");
    long[][] seedRanges;
    for (int i = 0; i < a.seeds.length; i+=2) {
        long seedRangeStart = a.seeds[i];
        long seedRangeLength = a.seeds[i+1];
        seedRanges ~= [seedRangeStart, seedRangeLength];
        writefln!"Mapping %d seeds starting from %d."(seedRangeLength, seedRangeStart);
    }
    foreach (long[] seedRange; parallel(seedRanges)) {
        long minValue = 1_000_000_000_000;
        const long seedCount = seedRange[1];
        for (long seed = seedRange[0]; seed < seedRange[0] + seedCount; seed++) {
            long value = seed;
            foreach (Mapping[] mappingSet; a.mappings) {
                bool mapped = false;
                foreach (Mapping mapping; mappingSet) {
                    if (mapping.containsSourceValue(value)) {
                        value = mapping.map(value);
                        mapped = true;
                        break;
                    }
                }
            }
            minValue = min(minValue, value);
        }
        writefln!"Done searching %d seeds, local min = %d"(seedCount, minValue);
    }
}

void main() {
    part1();
    part2();
}