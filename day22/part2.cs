using System;
using System.Collections.Generic;
using System.IO;

namespace part2
{
    enum ActiveTool
    {
        Neither,
        Torch,
        CGear
    }
    internal struct Node
    {
        internal int X;
        internal int Y;
        internal ActiveTool Tool;
        internal int ToolSwitch;
        internal int Distance;
        public override bool Equals(Object other)
        {
            if (other is Node nd)
            {
                return nd.X == X && nd.Y == Y && nd.Tool == Tool && nd.ToolSwitch == ToolSwitch;
            }
            return false;
        }
        public override int GetHashCode()
        {
            int hash = 7;
            hash = hash * 31 + X.GetHashCode();
            hash = hash * 31 + Y.GetHashCode();
            hash = hash * 31 + Tool.GetHashCode();
            hash = hash * 31 + ToolSwitch.GetHashCode();
            return hash;
        }
        internal List<Node> NodesAround(int depth)
        {
            List<Node> ndl = new List<Node>();
            if (ToolSwitch != 0)
            {
                Node nd = new Node();
                nd.X = X;
                nd.Y = Y;
                nd.Tool = Tool;
                nd.ToolSwitch = ToolSwitch - 1;
                nd.Distance = Distance + 1;
                ndl.Add(nd);
                return ndl;
            }
            if (X != 0)
            {
                if (Part2.CanEnter(X - 1, Y, depth, Tool)) {
                    Node nd = new Node();
                    nd.X = X - 1;
                    nd.Y = Y;
                    nd.Distance = Distance + 1;
                    nd.Tool = Tool;
                    nd.ToolSwitch = 0;
                    ndl.Add(nd);
                }
            }
            if (Y != 0)
            {
                if (Part2.CanEnter(X, Y - 1, depth, Tool)) {
                    Node nd = new Node();
                    nd.X = X;
                    nd.Y = Y - 1;
                    nd.Tool = Tool;
                    nd.ToolSwitch = 0;
                    nd.Distance = Distance + 1;
                    ndl.Add(nd);
                }
            }
            if (Part2.CanEnter(X + 1, Y, depth, Tool)) {
                Node nd = new Node();
                nd.X = X + 1;
                nd.Y = Y;
                nd.Tool = Tool;
                nd.ToolSwitch = 0;
                nd.Distance = Distance + 1;
                ndl.Add(nd);
            }
            if (Part2.CanEnter(X, Y + 1, depth, Tool)) {
                Node nd = new Node();
                nd.X = X;
                nd.Y = Y + 1;
                nd.Tool = Tool;
                nd.ToolSwitch = 0;
                nd.Distance = Distance + 1;
                ndl.Add(nd);
            }
            if (Tool != ActiveTool.Neither && Part2.CanEnter(X, Y, depth, ActiveTool.Neither)) {
                Node nd = new Node();
                nd.X = X;
                nd.Y = Y;
                nd.Tool = ActiveTool.Neither;
                nd.ToolSwitch = 6;
                nd.Distance = Distance + 1;
                ndl.Add(nd);
            }
            if (Tool != ActiveTool.CGear && Part2.CanEnter(X, Y, depth, ActiveTool.CGear)) {
                Node nd = new Node();
                nd.X = X;
                nd.Y = Y;
                nd.Tool = ActiveTool.CGear;
                nd.ToolSwitch = 6;
                nd.Distance = Distance + 1;
                ndl.Add(nd);
            }
            if (Tool != ActiveTool.Torch && Part2.CanEnter(X, Y, depth, ActiveTool.Torch)) {
                Node nd = new Node();
                nd.X = X;
                nd.Y = Y;
                nd.Tool = ActiveTool.Torch;
                nd.ToolSwitch = 6;
                nd.Distance = Distance + 1;
                ndl.Add(nd);
            }
            return ndl;
        }
    }
    class Part2
    {
        static List<List<long>> cache = new List<List<long>>();
        static int destx;
        static int desty;
        internal static bool CanEnter(int x, int y, int depth, ActiveTool tool)
        {
            long regKind = ErosionLevelCache(x, y, depth) % 3;
            if (regKind == 0)
            {
                return tool != ActiveTool.Neither;
            } else if (regKind == 1)
            {
                return tool != ActiveTool.Torch;
            } else
            {
                return tool != ActiveTool.CGear;
            }
        }
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
            HashSet<Node> visited = new HashSet<Node>();
            Queue<Node> queue = new Queue<Node>();
            Node start = new Node();
            start.Tool = ActiveTool.Torch;
            queue.Enqueue(start);
            while (queue.Count != 0)
            {
                Node nd = queue.Dequeue();
                if (visited.Contains(nd))
                {
                    continue;
                }
                visited.Add(nd);
                if (nd.X == destx && nd.Y == desty && nd.ToolSwitch == 0 && nd.Tool == ActiveTool.Torch)
                {
                    Console.WriteLine(nd.Distance);
                    return;
                }
                List<Node> neighbours = nd.NodesAround(depth);
                foreach (Node nod in neighbours)
                {
                    if (!visited.Contains(nod))
                    {
                        queue.Enqueue(nod);
                    }
                }
            }
        }
    }
}
