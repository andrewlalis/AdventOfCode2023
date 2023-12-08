import std.stdio;
import std.algorithm;
import std.string;
import std.array;
import std.math;

struct Node {
    string name, left, right;
}

struct Puzzle {
    string instructions;
    Node[string] nodes;
}

Puzzle parsePuzzle(string filename) {
    Puzzle p;
    string[] lines = File(filename).byLineCopy.array;
    p.instructions = lines[0].strip;
    foreach (string line; lines[2..$]) {
        string[] nameAndBranches = line.split("=");
        string name = nameAndBranches[0].strip;
        string[] branches = nameAndBranches[1].strip[1..$-1].split(",").map!strip.array;
        p.nodes[name] = Node(name, branches[0], branches[1]);
    }
    return p;
}

void part1() {
    Puzzle p = parsePuzzle("input.txt");
    Node currentNode = p.nodes["AAA"];
    size_t instructionIdx = 0;
    ulong steps = 0;
    while (currentNode.name != "ZZZ") {
        char instruction = p.instructions[instructionIdx++];
        if (instructionIdx >= p.instructions.length) instructionIdx = 0;
        if (instruction == 'L') {
            currentNode = p.nodes[currentNode.left];
        } else if (instruction == 'R') {
            currentNode = p.nodes[currentNode.right];
        }
        steps++;
    }
    writeln(steps);
}

void part2() {
    ulong gcd(ulong a, ulong b) {
        if (a < b) swap(a, b);
        while (b != 0) {
            a = a % b;
            swap(a, b);
        }
        return a;
    }

    ulong lcm(ulong a, ulong b) {
        return a / gcd(a, b) * b;
    }
    Puzzle p = parsePuzzle("input.txt");
    Node[] startNodes = p.nodes.values.filter!(n => n.name[$-1] == 'A').array;
    ulong lcmSteps = 1;
    foreach (size_t i, Node startNode; startNodes) {
        Node currentNode = startNode;
        ulong cycleLength = 0;
        size_t instructionIdx = 0;
        while (currentNode.name[$-1] != 'Z') {
            char instruction = p.instructions[instructionIdx++];
            if (instructionIdx >= p.instructions.length) instructionIdx = 0;
            currentNode = instruction == 'L' ? p.nodes[currentNode.left] : p.nodes[currentNode.right];
            cycleLength++;
        }
        lcmSteps = lcm(lcmSteps, cycleLength);
    }
    writeln(lcmSteps);
}

void main() {
    part1();
    part2();
}
