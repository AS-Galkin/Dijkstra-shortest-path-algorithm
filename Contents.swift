import UIKit

class Vertex {
    let description: String
    var minCost: Int = Int.max
    var isVisited: Bool = false
    var outEdges:[Edge] = []
    var previousVertex: Vertex? = nil
    
    init(description: String) {
        self.description = description
    }
    
}
extension Vertex: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
}

extension Vertex: Equatable {
    static func == (rhs: Vertex, lhs: Vertex) -> Bool {
        return rhs.hashValue == lhs.hashValue
    }
    
    static func < (lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.minCost < rhs.minCost
    }
}

class Edge {
    let cost: Int
    var startVertex: Vertex
    var endVertex: Vertex
    
    init(cost: Int, startVertex: Vertex, endVertex: Vertex) {
        self.cost = cost
        self.startVertex = startVertex
        self.endVertex = endVertex
    }
}


class Dijkstra {
    //vertexes compare with choosen vertex
    var adjectiveVertex: Set<Vertex> = []
    
    var minPath: Int? = Int.max
    
    //Minimal path to vertex
    var path: [Vertex] = []
    
    func calculatePath(startVertex: Vertex, endVertex: Vertex) -> Int? {
        startVertex.isVisited = true
        startVertex.minCost = 0
        
        var currentVertex: Vertex? = startVertex
        
        while let vertex = currentVertex {
            
            guard vertex != endVertex else {
                minPath = currentVertex?.minCost
                restorePath(vertex: currentVertex!)
                currentVertex = nil
                return minPath
            }
            
            for edge in vertex.outEdges {
                
                if vertex.minCost + edge.cost < edge.endVertex.minCost {
                    edge.endVertex.minCost = vertex.minCost + edge.cost
                    edge.endVertex.previousVertex = edge.startVertex
                }
                adjectiveVertex.insert(edge.endVertex)
            }
            currentVertex?.isVisited = true
            adjectiveVertex.remove(vertex)
            currentVertex = adjectiveVertex.min(by: { $0 < $1 })
        }
        
        return nil
    }
    
    func restorePath(vertex: Vertex) {
        path.insert(vertex, at: 0)
        
        if vertex.previousVertex != nil {
            restorePath(vertex: vertex.previousVertex!)
        }
    }
}


var vA: Vertex = Vertex(description: "A")
var vB: Vertex = Vertex(description: "B")
var vC: Vertex = Vertex(description: "C")
var vD: Vertex = Vertex(description: "D")
var vE: Vertex = Vertex(description: "E")

let edge1: Edge = Edge(cost: 3, startVertex: vA, endVertex: vB)
let edge2: Edge = Edge(cost: 6, startVertex: vA, endVertex: vC)
let edge3: Edge = Edge(cost: 1, startVertex: vA, endVertex: vD)
let edge4: Edge = Edge(cost: 5, startVertex: vB, endVertex: vE)
let edge5: Edge = Edge(cost: 4, startVertex: vC, endVertex: vE)
let edge6: Edge = Edge(cost: 4, startVertex: vD, endVertex: vC)
let edge7: Edge = Edge(cost: 12, startVertex: vD, endVertex: vE)


vA.outEdges = [edge1, edge2, edge3]
vB.outEdges = [edge4]
vC.outEdges = [edge5]
vD.outEdges = [edge6, edge7]


let minPath: Dijkstra = Dijkstra()

print(minPath.calculatePath(startVertex: vA, endVertex: vC))

for i in minPath.path {
    print("Yor way is \(i.description)")
}

