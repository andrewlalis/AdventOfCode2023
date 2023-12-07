import std.stdio;
import std.algorithm;
import std.conv;
import std.array;
import std.string;
import std.ascii;

enum HandType : ubyte {
    FiveOfAKind = 7,
    FourOfAKind = 6,
    FullHouse = 5,
    ThreeOfAKind = 4,
    TwoPair = 3,
    OnePair = 2,
    HighCard = 1
}

struct Hand {
    ubyte[5] cards;
    long bid;
    HandType type;
}

HandType getType(ubyte[5] cards) {
    ubyte[15] freq;
    ubyte maxFreq = 0;
    foreach (ubyte c; cards) {
        freq[c]++;
        if (freq[c] > maxFreq) maxFreq = freq[c];
    }
    ubyte jokerFreq = freq[1];
    ubyte maxNonJokerFreq = freq[2..$].maxElement;
    ubyte nonJokerCardTypes = cast(ubyte) freq[2..$].count!(n => n != 0);
    if (maxNonJokerFreq + jokerFreq == 5) return HandType.FiveOfAKind;
    if (maxNonJokerFreq + jokerFreq == 4) return HandType.FourOfAKind;
    if (maxNonJokerFreq + jokerFreq == 3 && nonJokerCardTypes == 2) return HandType.FullHouse;
    if (maxNonJokerFreq + jokerFreq == 3) return HandType.ThreeOfAKind;
    if (maxNonJokerFreq + jokerFreq == 2 && nonJokerCardTypes == 3) return HandType.TwoPair;
    if (maxNonJokerFreq + jokerFreq == 2) return HandType.OnePair;
    return HandType.HighCard;
}

bool compareHands(Hand a, Hand b) {
    if (a.type > b.type) return false;
    if (b.type > a.type) return true;
    for (size_t i = 0; i < 5; i++) {
        if (a.cards[i] > b.cards[i]) return false;
        if (b.cards[i] > a.cards[i]) return true;
    }
    return false;
}

Hand[] parseHands(string filename, bool weakJoker) {
    Hand[] hands;
    foreach (string line; File(filename).byLineCopy()) {
        string[] parts = line.split();
        Hand h;
        h.bid = parts[1].to!long;
        foreach (size_t i, char c; parts[0]) {
            if (isDigit(c)) h.cards[i] = cast(ubyte) (c - '0');
            else if (c == 'T') h.cards[i] = 10;
            else if (c == 'J') h.cards[i] = weakJoker ? 1 : 11;
            else if (c == 'Q') h.cards[i] = 12;
            else if (c == 'K') h.cards[i] = 13;
            else if (c == 'A') h.cards[i] = 14;
        }
        h.type = getType(h.cards);
        hands ~= h;
    }
    return hands;
}

void computeRankedBidSum(string filename, bool weakJoker) {
    Hand[] hands = parseHands(filename, weakJoker);
    long[] bidsRanked = hands.sort!compareHands.map!(h => h.bid).array;
    long sum = 0;
    for (long i = 0; i < bidsRanked.length; i++) {
        sum += (i + 1) * bidsRanked[i];
    }
    writeln(sum);
}

void part1() {
    computeRankedBidSum("input.txt", false);
}

void part2() {
    computeRankedBidSum("input.txt", true);
}

void main() {
    part1();
    part2();
}
