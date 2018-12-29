package aoc;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class Part1 {
    private static class Vector4d {
        public int x;
        public int y;
        public int z;
        public int w;
        public Set<Vector4d> constellation;
        public int manhattan(Vector4d other) {
            return Math.abs(x - other.x) + Math.abs(y - other.y) + Math.abs(z - other.z) + Math.abs(w - other.w);
        }
    }
    private static void mergeConstellations(Vector4d a, Vector4d b) {
        Set<Vector4d> mergee = b.constellation;
        a.constellation.addAll(mergee);
        for (Vector4d pt : mergee) {
            pt.constellation = a.constellation;
        }
    }
    public static void main(String[] args) throws Exception {
        List<String> lines = Files.readAllLines(Path.of("in.txt"));
        List<Vector4d> points = new ArrayList<>();
        for (String line : lines) {
            String[] crd = line.split(",");
            Vector4d pt = new Vector4d();
            pt.x = Integer.parseInt(crd[0]);
            pt.y = Integer.parseInt(crd[1]);
            pt.z = Integer.parseInt(crd[2]);
            pt.w = Integer.parseInt(crd[3]);
            pt.constellation = new HashSet<>(List.of(pt));
            points.add(pt);
        }
        for (Vector4d a : points) {
            for (Vector4d b : points) {
                if (a.constellation == b.constellation) {
                    continue;
                }
                if (a.manhattan(b) <= 3) {
                    mergeConstellations(a, b);
                }
            }
        }
        long nconst = points.stream().map((x) -> x.constellation).distinct().count();
        System.out.println(nconst);
    }
}
