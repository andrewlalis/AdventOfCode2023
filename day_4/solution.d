import std.stdio;
import std.algorithm;
import std.string;
import std.array;
import std.conv;
import std.uni;

int countMatchingNumbers(string card) {
    const string[] parts = split(card, "|");
    const int[] winningNums = split(parts[0], ":")[1].split(" ")
        .filter!(s => s.length > 0)
        .map!(s => s.strip.to!int)
        .array;
    return parts[1].split(" ")
        .filter!(s => s.length > 0)
        .map!(s => s.strip.to!int)
        .map!(n => canFind(winningNums, n) ? 1 : 0)
        .sum;
}

void part1() {
    File("input.txt").byLineCopy()
        .map!(s => countMatchingNumbers(s))
        .map!(n => n < 2 ? n : 1 << n-1)
        .sum.writeln;
}

void part2() {
    int[] matchesPerCard = File("input.txt").byLineCopy().map!countMatchingNumbers.array;
    int[] cardCounts = new int[matchesPerCard.length];
    cardCounts[] = 1; // Set all card counts to 1 initially.
    for (int card = 0; card < cardCounts.length; card++) {
        for (int i = 1; i < matchesPerCard[card] + 1; i++) {
            cardCounts[card+i] += cardCounts[card];
        }
    }
    cardCounts.sum.writeln;
}

void main() {
    part1();
    part2();
}