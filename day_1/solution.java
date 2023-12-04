import java.nio.file.Files;
import java.nio.file.Path;

class solution {
    private interface DigitFinder {
        int getDigit(String s, int idx);
    }

    private static int parseDigits(DigitFinder df, String s) {
        int a = -1, b = -1;
        for (int i = 0; i < s.length(); i++) {
            int an = df.getDigit(s, i);
            int bn = df.getDigit(s, s.length() - i - 1);
            if (a == -1 && an != -1) a = an;
            if (b == -1 && bn != -1) b = bn;
            if (a != -1 && b != -1) break;
        }
        return a * 10 + b;
    }

    private static class Part1DigitFinder implements DigitFinder {
        public int getDigit(String s, int idx) {
            if (Character.isDigit(s.charAt(idx))) {
                return s.charAt(idx) - '0';
            }
            return -1;
        }
    }

    private static void part1() throws Exception {
        var df = new Part1DigitFinder();
        int sum = Files.readAllLines(Path.of("part_1_input.txt")).stream()
            .mapToInt(line -> parseDigits(df, line))
            .sum();
        System.out.println(sum);
    }

    private static class Part2DigitFinder implements DigitFinder {
        public int getDigit(String s, int idx) {
            if (Character.isDigit(s.charAt(idx))) return s.charAt(idx) - '0';
            String[] words = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"};
            for (int i = 0; i < words.length; i++) {
                String word = words[i];
                if (s.length() - idx >= word.length() && s.substring(idx, idx + word.length()).equals(word)) {
                    return i + 1;
                }
            }
            return -1;
        }
    }

    private static void part2() throws Exception {
        var df = new Part2DigitFinder();
        int sum = Files.readAllLines(Path.of("part_2_input.txt")).stream()
            .mapToInt(line -> parseDigits(df, line))
            .sum();
        System.out.println(sum);
    }

    public static void main(String[] args) throws Exception {
        part1();
        part2();
    }
}