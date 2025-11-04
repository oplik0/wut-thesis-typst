// For local testing, use: #import "../src/lib.typ": simple-doc, code-listing, callout
// For published package, use:
#import "@preview/wut-thesis:0.1.1": simple-doc, code-listing, callout

#show: simple-doc.with(
  doc-type: "notes",
  title: "Data Structures & Algorithms - Lecture Notes",
  author: "Student Name",
  course: "CS 301: Data Structures",
  date: datetime(year: 2025, month: 11, day: 4),
  lang: "en",
  show-toc: true,
  draft: false,
)

= Binary Search Trees

A Binary Search Tree (BST) is a binary tree where each node has at most two children, and for each node:
- Left subtree contains only nodes with values less than the node's value
- Right subtree contains only nodes with values greater than the node's value

== Properties

*Time Complexities:*
- Search: $O(log n)$ average, $O(n)$ worst case
- Insert: $O(log n)$ average, $O(n)$ worst case  
- Delete: $O(log n)$ average, $O(n)$ worst case

#callout(type: "note")[
  Worst case occurs when tree becomes skewed (essentially a linked list)
]

== Implementation

#code-listing(
  caption: [BST Node class in Python],
  lang: "python",
)[```python
class Node:
    def __init__(self, value):
        self.value = value
        self.left = None
        self.right = None

class BST:
    def __init__(self):
        self.root = None
    
    def insert(self, value):
        if self.root is None:
            self.root = Node(value)
        else:
            self._insert_recursive(self.root, value)
    
    def _insert_recursive(self, node, value):
        if value < node.value:
            if node.left is None:
                node.left = Node(value)
            else:
                self._insert_recursive(node.left, value)
        else:
            if node.right is None:
                node.right = Node(value)
            else:
                self._insert_recursive(node.right, value)
```]

== Traversal Methods

*In-order traversal* (Left → Root → Right): Gives sorted order
$ "visit"(n) = { "visit"(n."left"), "process"(n), "visit"(n."right") } $

*Pre-order traversal* (Root → Left → Right): Used for copying tree

*Post-order traversal* (Left → Right → Root): Used for deleting tree

= AVL Trees

AVL trees are self-balancing BSTs where the heights of left and right subtrees differ by at most 1.

== Balance Factor

$"Balance Factor" = "height"("left subtree") - "height"("right subtree")$

Valid balance factors: -1, 0, +1

#callout(type: "important", title: "Key Concept")[
  When balance factor becomes ±2 after insertion/deletion, we need to perform rotations to rebalance.
]

== Rotation Types

*Left Rotation:* Used when right subtree is too heavy

*Right Rotation:* Used when left subtree is too heavy

*Left-Right Rotation:* First left rotate child, then right rotate parent

*Right-Left Rotation:* First right rotate child, then left rotate parent

= Hash Tables

Hash tables provide $O(1)$ average time complexity for insert, delete, and search operations.

== Hash Function Requirements

Good hash function should:
1. Be deterministic (same input → same output)
2. Distribute keys uniformly
3. Be fast to compute
4. Minimize collisions

== Collision Resolution

*Chaining:* Each bucket contains a linked list
- Simple to implement
- Can accommodate more items than table size
- Performance degrades gracefully

*Open Addressing:* Find next available slot
- Linear probing: Check next slot $(h(k) + i) mod m$
- Quadratic probing: $(h(k) + i^2) mod m$
- Double hashing: $(h_1(k) + i dot h_2(k)) mod m$

== Load Factor

$ alpha = n / m $

Where:
- $n$ = number of elements
- $m$ = table size

#callout(type: "warning")[
  When $alpha > 0.7$, consider resizing table to maintain performance
]

= Graph Algorithms

== Breadth-First Search (BFS)

Uses queue, explores level by level.

*Applications:*
- Shortest path in unweighted graph
- Level-order traversal
- Testing bipartiteness

*Time complexity:* $O(V + E)$ where $V$ = vertices, $E$ = edges

== Depth-First Search (DFS)

Uses stack (or recursion), explores as deep as possible.

*Applications:*
- Detecting cycles
- Topological sorting
- Finding connected components

*Time complexity:* $O(V + E)$

== Dijkstra's Algorithm

Finds shortest path in weighted graph with non-negative weights.

#code-listing(
  caption: [Dijkstra's algorithm pseudocode],
  lang: "python",
)[```python
def dijkstra(graph, start):
    distances = {node: infinity for node in graph}
    distances[start] = 0
    pq = PriorityQueue()
    pq.put((0, start))
    visited = set()
    
    while not pq.empty():
        current_dist, current = pq.get()
        
        if current in visited:
            continue
        visited.add(current)
        
        for neighbor, weight in graph[current]:
            distance = current_dist + weight
            if distance < distances[neighbor]:
                distances[neighbor] = distance
                pq.put((distance, neighbor))
    
    return distances
```]

*Time complexity:* $O((V + E) log V)$ with binary heap

#callout(type: "info")[
  Cannot handle negative weights! Use Bellman-Ford for graphs with negative edges.
]

= Dynamic Programming

DP solves problems by breaking them into overlapping subproblems.

== Key Characteristics

1. *Optimal substructure:* Optimal solution contains optimal solutions to subproblems
2. *Overlapping subproblems:* Same subproblems solved multiple times

== Common Patterns

*Top-down (Memoization):*
- Recursive approach
- Store computed results
- Natural to write

*Bottom-up (Tabulation):*
- Iterative approach  
- Build solution from smallest subproblems
- Better space efficiency

== Example: Fibonacci

Naive recursion: $O(2^n)$

With memoization: $O(n)$

$ F(n) = cases(
  0 quad & "if" n = 0,
  1 quad & "if" n = 1,
  F(n-1) + F(n-2) quad & "if" n > 1
) $

= Quick Reference

#figure(
  table(
    columns: 4,
    [*Data Structure*], [*Insert*], [*Search*], [*Delete*],
    [Array], [$O(n)$], [$O(n)$], [$O(n)$],
    [Linked List], [$O(1)$], [$O(n)$], [$O(1)$],
    [BST (balanced)], [$O(log n)$], [$O(log n)$], [$O(log n)$],
    [Hash Table], [$O(1)$*], [$O(1)$*], [$O(1)$*],
    [Heap], [$O(log n)$], [$O(n)$], [$O(log n)$],
  ),
  caption: [Time complexities (* = average case)]
)
