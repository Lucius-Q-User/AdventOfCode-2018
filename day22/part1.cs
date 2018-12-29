using System;
using System.Collections.Generic;
using System.IO;

namespace part1
{
    class Part1
    {
        static List<List<long>> cache = new List<List<long>>();
        static int destx;
        static int desty;
        static long ErosionLevelCache(int x, int y, int depth)
        {
            while (cache.Count <= y)
            {
                cache.Add(new List<long>());
            }
            List<long> cacheLine = cache[y];
            for (int i = cacheLine.Count; i <= x; i++)
            {
                cacheLine.Add(ErosionLevel(i, y, depth));
            }
            return cacheLine[x];
        }
        static long ErosionLevel(int x, int y, int depth)
        {
            if ((y == 0 && x == 0) || (x == destx && y == desty))
            {
                return depth % 20183;
            }
            if (y == 0)
            {
                return (x * 16807L + depth) % 20183;
            }
            if (x == 0)
            {
                return (y * 48271L + depth) % 20183;
            }
            return (ErosionLevelCache(x, y - 1, depth) * ErosionLevelCache(x - 1, y, depth) + depth) % 20183;
        }
        static void Main(string[] args)
        {
            string[] lines = File.ReadAllLines("in.txt");
            int depth = int.Parse(lines[0].Split(' ')[1]);
            string[] coord = lines[1].Split(' ')[1].Split(',');
            destx = int.Parse(coord[0]);
            desty = int.Parse(coord[1]);
            ErosionLevelCache(destx, desty, depth);
            long level = 0;
            for (int x = 0; x <= destx; x++)
            {
                for (int y = 0; y <= desty; y++)
                {
                    level += ErosionLevelCache(x, y, depth) % 3;
                }
            }
            Console.WriteLine(level);
        }
    }
}
