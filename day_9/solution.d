import std.stdio;
import std.algorithm;
import std.array;
import std.string;
import std.conv;

bool isLinear(long[] numbers) {
    if (numbers.length < 2) return true;
    const long diff = numbers[1] - numbers[0];
    for (int i = 1; i + 1 < numbers.length; i++) {
        if (numbers[i] - numbers[i-1] != diff) return false;
    }
    return true;
}

long[] computeNextOrder(long[] numbers) {
    if (numbers.length < 2) return [];
    long[] diffs = new long[](numbers.length - 1);
    for (int i = 1; i < numbers.length; i++) {
        diffs[i-1] = numbers[i] - numbers[i-1];
    }
    return diffs;
}

long extrapolateHistory(long[] numbers) {
    long[] lastValues = [numbers[$-1]];
    long[] currentSequence = numbers.dup;
    while (!isLinear(currentSequence)) {
        currentSequence = computeNextOrder(currentSequence);
        lastValues ~= currentSequence[$-1];
    }
    const long linearDiff = currentSequence[$-1] - currentSequence[$-2];
    long nextValue = lastValues[$-1] + linearDiff;
    while (lastValues.length > 1) {
        lastValues = lastValues[0..$-1];
        nextValue = lastValues[$-1] + nextValue;
    }
    return nextValue;
}

long extrapolateHistoryBack(long[] numbers) {
    long[] lastValues = [numbers[0]];
    long[] currentSequence = numbers.dup;
    while (!isLinear(currentSequence)) {
        currentSequence = computeNextOrder(currentSequence);
        lastValues ~= currentSequence[0];
    }
    const long linearDiff = currentSequence[$-1] - currentSequence[$-2];
    long nextValue = lastValues[$-1] - linearDiff;
    while (lastValues.length > 1) {
        lastValues = lastValues[0..$-1];
        nextValue = lastValues[$-1] - nextValue;
    }
    return nextValue;
}

void part1() {
    File("input.txt").byLineCopy.map!(s => s.strip.split.map!(to!long).array)
        .map!extrapolateHistory.sum.writeln;
}

void part2() {
    File("input.txt").byLineCopy.map!(s => s.strip.split.map!(to!long).array)
        .map!extrapolateHistoryBack.sum.writeln;
}

void main() {
    part1();
    part2();
}
